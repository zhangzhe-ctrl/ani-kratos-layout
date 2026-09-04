# Runtime Component Coverage Matrix

- Contract source: [../runtime.md](../runtime.md)
- Candidate revision: **not yet recorded**
- Overall status: **not_verified**

Every row is required for LAYOUT-0 unless explicitly marked as a policy-only
row. Source presence is necessary but does not prove runtime behavior.

| ID | Component or invariant | Expected implementation seam | Required evidence | Status |
| --- | --- | --- | --- | --- |
| C01 | typed file configuration | `internal/conf/v1/conf.proto`, `cmd/server/main.go` | generated-code diff clean; config load test | not_verified |
| C02 | `ANI` environment overrides | `cmd/server/main.go` | isolated env override test | not_verified |
| C03 | configuration validation | `internal/conf/v1/validate.go` | table tests for valid and invalid networks, IPs, ports, duplicate listeners, and timeouts | not_verified |
| C04 | safe local listener defaults | `configs/config.yaml` | parse/validate test; static assertion for loopback addresses | not_verified |
| C05 | explicit composition root | `cmd/server/app.go` | source review; build without Wire | not_verified |
| C06 | Kratos application lifecycle | `cmd/server/app.go`, `cmd/server/main.go` | process start and signal-stop test | not_verified |
| C07 | structured JSON logger | `cmd/server/main.go` | log decode test with required service fields | not_verified |
| C08 | trace/span correlation fields | logger construction and tracing middleware | request test with trace context | not_verified |
| C09 | sensitive-log filtering seam | logger construction | source assertion and focused test where feasible | not_verified |
| C10 | `automaxprocs` logger bridge | `cmd/server/main.go` | source/build assertion | not_verified |
| C11 | gRPC server | `internal/server/grpc.go` | socket-level health probe | not_verified |
| C12 | standard gRPC health service | `internal/server/grpc.go` | health `Check` returns serving after startup | not_verified |
| C13 | reflection disabled by default | `internal/server/grpc.go` | reflection request fails with expected status | not_verified |
| C14 | middleware: recovery | gRPC server construction | panic-path focused test or static constructor assertion | not_verified |
| C15 | middleware: metadata | gRPC server construction | metadata propagation test | not_verified |
| C16 | middleware: tracing | gRPC server construction | span/request test | not_verified |
| C17 | middleware: logging | gRPC server construction | request log assertion | not_verified |
| C18 | middleware: metrics | gRPC server construction | request increments exposed metric | not_verified |
| C19 | middleware: validation | gRPC server construction | invalid request rejected before handler work | not_verified |
| C20 | frozen middleware order | gRPC server construction | constructor/source contract test | not_verified |
| C21 | Kratos error/codec boundary | gRPC and admin construction | error encoding/content-type test | not_verified |
| C22 | admin HTTP server | `internal/server/admin.go` | real listener probe | not_verified |
| C23 | `/healthz` | admin route | HTTP status/body test | not_verified |
| C24 | `/readyz` process lifecycle | `internal/server/readiness.go`, admin route | pre-run/run/stopping state test | not_verified |
| C25 | process-only readiness semantics | runtime docs and readiness implementation | source/test assertion; no dependency claims | not_verified |
| C26 | `/metrics` | `internal/server/observability.go`, admin route | Prometheus text-format probe | not_verified |
| C27 | `ani_runtime_ready` gauge | observability/readiness | metric sample changes with lifecycle | not_verified |
| C28 | OpenTelemetry lifecycle | observability construction and cleanup | initialization/shutdown test without external collector claim | not_verified |
| C29 | graceful shutdown timeout | config and application lifecycle | signal-stop deadline test | not_verified |
| C30 | no business API | repository paths and dependency graph | forbidden-path/symbol scan | not_verified |
| C31 | no DB/broker/cache/provider default | `go.mod`, config, source tree | dependency and config scan | not_verified |
| C32 | empty biz/data/service extension seams | `internal/biz`, `internal/data`, `internal/service` | source scan and build | not_verified |
| C33 | no shared layout runtime dependency | generated `go.mod` and imports | isolated generated-service build after hiding layout checkout | not_verified |
| C34 | deterministic provenance | `scripts/new-service` | two same-input generations compare byte-for-byte, excluding `.git` | not_verified |
| C35 | full Go module path support | `scripts/new-service` | generate at least two distinct full module paths and inspect module/imports | not_verified |
| C36 | fail-closed destination handling | `scripts/new-service` | existing target, invalid module, dirty layout, generator mismatch, and simulated CLI error tests | not_verified |
| C37 | pinned generation tools | Makefile and Buf configuration | static scan rejects `@latest`; tool identity evidence | not_verified |
| C38 | generated-code reproducibility | Buf configuration and generated protobuf | regenerate and require clean Git diff | not_verified |

## Coverage rule

LAYOUT-0 runtime coverage is `pass` only when every C01–C38 row is either:

- supported by retained evidence and marked `pass`; or
- explicitly removed from the frozen L1–L4 contract by a reviewed decision.

An endpoint returning HTTP 200 alone does not establish the middleware,
telemetry, readiness semantics, graceful shutdown, or generated-repository
independence rows.
