SHELL := /bin/bash
.SHELLFLAGS := -Eeuo pipefail -c

GO ?= go
TOOLS_DIR := $(CURDIR)/.tools/bin
BUF := $(TOOLS_DIR)/buf
GOVULNCHECK := $(TOOLS_DIR)/govulncheck
CYCLONEDX_GOMOD := $(TOOLS_DIR)/cyclonedx-gomod

BUF_VERSION := v1.60.0
GOVULNCHECK_VERSION := v1.7.0
CYCLONEDX_GOMOD_VERSION := v1.12.0
BUF_MODULE := github.com/bufbuild/buf@$(BUF_VERSION)
GOVULNCHECK_MODULE := golang.org/x/vuln@$(GOVULNCHECK_VERSION)
CYCLONEDX_GOMOD_MODULE := github.com/CycloneDX/cyclonedx-gomod@$(CYCLONEDX_GOMOD_VERSION)

SERVICE_NAME ?= ani-service-template
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
LDFLAGS := -X main.Name=$(SERVICE_NAME) -X main.Version=$(VERSION)

.PHONY: tools check-buf supply-chain-tools check-govulncheck check-cyclonedx config generate build test verify vuln sbom clean help

tools: check-buf

$(BUF):
	mkdir -p $(TOOLS_DIR)
	GOBIN=$(TOOLS_DIR) $(GO) install github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION)

check-buf: $(BUF)
	test "$$($(BUF) --version)" = "$(patsubst v%,%,$(BUF_VERSION))"
	test "$$(go version -m $(BUF) | awk '$$1 == "mod" {print $$2 "@" $$3; exit}')" = "$(BUF_MODULE)"

supply-chain-tools: check-govulncheck check-cyclonedx

$(GOVULNCHECK):
	mkdir -p $(TOOLS_DIR)
	GOBIN=$(TOOLS_DIR) $(GO) install golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION)

check-govulncheck: $(GOVULNCHECK)
	$(GOVULNCHECK) -version | grep --fixed-strings --line-regexp "Scanner: govulncheck@$(GOVULNCHECK_VERSION)"
	test "$$(go version -m $(GOVULNCHECK) | awk '$$1 == "mod" {print $$2 "@" $$3; exit}')" = "$(GOVULNCHECK_MODULE)"

$(CYCLONEDX_GOMOD):
	mkdir -p $(TOOLS_DIR)
	GOBIN=$(TOOLS_DIR) $(GO) install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@$(CYCLONEDX_GOMOD_VERSION)

check-cyclonedx: $(CYCLONEDX_GOMOD)
	test "$$($(CYCLONEDX_GOMOD) version | awk -F '\t' '$$1 == "Version:" {print $$2}')" = "$(CYCLONEDX_GOMOD_VERSION)"
	test "$$(go version -m $(CYCLONEDX_GOMOD) | awk '$$1 == "mod" {print $$2 "@" $$3; exit}')" = "$(CYCLONEDX_GOMOD_MODULE)"

config: $(BUF)
	$(BUF) lint
	$(BUF) build
	$(BUF) generate --template buf.gen.yaml

generate: config
	$(GO) generate ./...
	find . -type f -name '*.go' -not -path './.git/*' -not -path './.tools/*' -print0 | xargs -0 --no-run-if-empty gofmt -w

build:
	mkdir -p bin
	$(GO) build -trimpath -ldflags "$(LDFLAGS)" -o bin/$(SERVICE_NAME) ./cmd/...

test:
	$(GO) test -count=1 ./...

verify: check-buf
	./scripts/verify-source $(BUF)
	$(GO) mod tidy -diff
	$(GO) test -count=1 ./...
	$(GO) vet ./...
	$(GO) build -trimpath ./...
	$(GO) mod verify
	git diff --check

vuln: check-govulncheck
	$(GOVULNCHECK) -show version,verbose ./...

sbom: check-cyclonedx
	./scripts/generate-sbom $(CYCLONEDX_GOMOD)

clean:
	rm -rf bin .tools .work .tmp

help:
	@echo "make tools    install pinned config generator"
	@echo "make generate regenerate typed config"
	@echo "make verify   run deterministic local quality gates"
	@echo "make vuln     scan the current dependency graph"
	@echo "make sbom     write a CycloneDX SBOM"

.DEFAULT_GOAL := help
