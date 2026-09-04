# ANI Kratos Layout

`ani-kratos-layout` is ANI's standalone, build-time template for long-lived Go
services. It keeps the official Kratos generator as the scaffold engine and
adds one fail-closed bootstrap interface for the gaps that the pinned CLI does
not cover.

LAYOUT-0 is a local candidate awaiting its explicit human acceptance gate.

## Generate a service

Prerequisites are Git, Go, `rg`, SHA-256 tooling, and the pinned official
Kratos CLI described in `docs/scaffold/upstream-provenance.md`.

Install the pinned Buf generator first:

```bash
make tools
```

```bash
./scripts/new-service \
  github.com/zhangzhe-ctrl/ani-notification-service \
  --parent /home/chabking/workspace
```

The target directory must not exist. Generation happens in a private temporary
directory and is moved into place only after structural checks pass. The module
must match `github.com/zhangzhe-ctrl/<lowercase-service-name>` exactly.

## What the generated service owns

- Kratos application lifecycle and graceful shutdown.
- Typed file/environment configuration.
- Structured, redacted JSON logging.
- gRPC plus a separate admin HTTP transport.
- gRPC health and `/healthz`, `/readyz`, `/metrics` admin endpoints.
- Recovery, metadata, tracing, logging, metrics, and validation middleware.
- Explicit composition without a shared runtime library or DI framework.

The generated repository is an independent source snapshot. It does not import,
link to, or automatically synchronize with this layout repository.

The retained `THIRD_PARTY_NOTICES.go-kratos-layout.txt` is the upstream Kratos
layout MIT notice, not a license grant for ANI-authored changes. Each generated
service owner must choose and add that repository's project license before
publication.

## Deliberate omissions

There is no example business API, database, queue, cache, auth, registry,
provider integration, container image, or deployment manifest. Those choices
belong to a real vertical slice and must not be enabled by template switches.

See `docs/LAYOUT-0.md` for the frozen decision and `docs/runtime.md` for the
runtime contract.

From a committed candidate, `make supply-chain-tools && make audit` runs the
pinned vulnerability and secret scanners, regenerates the runtime SBOM, and
checks its license evidence plus the retained upstream notice.
