SHELL := /bin/bash

GO ?= go
TOOLS_DIR := $(CURDIR)/.tools/bin
BUF := $(TOOLS_DIR)/buf
GOVULNCHECK := $(TOOLS_DIR)/govulncheck
CYCLONEDX_GOMOD := $(TOOLS_DIR)/cyclonedx-gomod

BUF_VERSION := v1.60.0
GOVULNCHECK_VERSION := v1.7.0
CYCLONEDX_GOMOD_VERSION := v1.12.0

SERVICE_NAME ?= ani-service-template
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
LDFLAGS := -X main.Name=$(SERVICE_NAME) -X main.Version=$(VERSION)

.PHONY: tools supply-chain-tools config generate build test verify vuln sbom clean help

tools: $(BUF)

$(BUF):
	mkdir -p $(TOOLS_DIR)
	GOBIN=$(TOOLS_DIR) $(GO) install github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION)

supply-chain-tools: $(GOVULNCHECK) $(CYCLONEDX_GOMOD)

$(GOVULNCHECK):
	mkdir -p $(TOOLS_DIR)
	GOBIN=$(TOOLS_DIR) $(GO) install golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION)

$(CYCLONEDX_GOMOD):
	mkdir -p $(TOOLS_DIR)
	GOBIN=$(TOOLS_DIR) $(GO) install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@$(CYCLONEDX_GOMOD_VERSION)

config: $(BUF)
	$(BUF) lint
	$(BUF) build
	$(BUF) generate --template buf.gen.yaml

generate: config
	$(GO) generate ./...
	gofmt -w $$(find . -name '*.go' -not -path './.git/*' -not -path './.tools/*')

build:
	mkdir -p bin
	$(GO) build -trimpath -ldflags "$(LDFLAGS)" -o bin/$(SERVICE_NAME) ./cmd/...

test:
	$(GO) test -count=1 ./...

verify: $(BUF)
	@before=$$(sha256sum internal/conf/v1/conf.pb.go); \
		$(MAKE) --no-print-directory config >/dev/null; \
		after=$$(sha256sum internal/conf/v1/conf.pb.go); \
		test "$$before" = "$$after" || { echo "generated config is stale" >&2; exit 1; }
	@test -z "$$(gofmt -l $$(find . -name '*.go' -not -path './.git/*' -not -path './.tools/*'))" || { \
		echo "gofmt check failed" >&2; \
		gofmt -l $$(find . -name '*.go' -not -path './.git/*' -not -path './.tools/*'); \
		exit 1; \
	}
	$(GO) generate ./...
	$(GO) mod tidy -diff
	$(GO) test -count=1 ./...
	$(GO) vet ./...
	$(GO) build -trimpath ./...
	$(GO) mod verify
	git diff --check

vuln: $(GOVULNCHECK)
	$(GOVULNCHECK) -show verbose ./...

sbom: $(CYCLONEDX_GOMOD)
	$(CYCLONEDX_GOMOD) mod -json -noserial -notimestamp -licenses -assert-licenses \
		-output docs/scaffold/bom.cdx.json

clean:
	rm -rf bin .tools .work .tmp

help:
	@echo "make tools    install pinned config generator"
	@echo "make generate regenerate typed config"
	@echo "make verify   run deterministic local quality gates"
	@echo "make vuln     scan the current dependency graph"
	@echo "make sbom     write a CycloneDX SBOM"

.DEFAULT_GOAL := help
