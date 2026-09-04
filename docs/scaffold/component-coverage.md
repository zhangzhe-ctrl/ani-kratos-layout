# Runtime Component Coverage Matrix

- Contract source: [../runtime.md](../runtime.md)
- Candidate identity: local tag `layout-0-candidate`
- Local technical status: **pass**

Source presence is not treated as runtime evidence. The rows below link each
frozen component to an executable probe or a retained source/dependency gate.

| ID | Component or invariant | Retained evidence | Status |
| --- | --- | --- | --- |
| C01 | typed file configuration | Buf regeneration and `TestCommittedConfigLoadsAsGeneratedType` | pass |
| C02 | `ANI` environment overrides | `TestCommittedConfigLoadsAsGeneratedType` and independent command test | pass |
| C03 | configuration validation | table tests cover missing objects, networks, IPv4/IPv6 literals, ports, numeric-equivalent conflicts, malformed/zero/negative/oversized durations | pass |
| C04 | safe local listener defaults | committed config parse plus validation; defaults are `127.0.0.1` | pass |
| C05 | explicit composition root | `cmd/server/app.go`; Wire/source policy scan | pass |
| C06 | Kratos application lifecycle | production `buildApp` test and independent process signal test | pass |
| C07 | structured JSON logger | JSON decode asserts timestamp, caller, service id/name/version | pass |
| C08 | trace/span correlation fields | production request log and middleware fixture | pass |
| C09 | sensitive-log filtering seam | focused Kratos FilterKey redaction test | pass |
| C10 | `automaxprocs` logger bridge | production command source/build and shared logger path | pass |
| C11 | gRPC server | real loopback listener probes | pass |
| C12 | standard gRPC health | health `Check` returns `SERVING` | pass |
| C13 | reflection disabled | reflection request returns `Unimplemented` | pass |
| C14 | recovery middleware | test-only RPC panic becomes gRPC `Internal` | pass |
| C15 | metadata middleware | test-only RPC receives `x-md-layout-caller` through Kratos metadata | pass |
| C16 | tracing middleware | request log contains non-empty trace/span identifiers | pass |
| C17 | logging middleware | request emits Kratos `server request` JSON record | pass |
| C18 | metrics middleware | request counter appears in Prometheus exposition | pass |
| C19 | validation middleware | invalid request is rejected before fixture call count changes | pass |
| C20 | frozen middleware order | literal constructor review plus combined recovery/metadata/tracing/logging/metrics/validation execution | pass |
| C21 | Kratos error/codec boundary | admin not-ready error and gRPC statuses use Kratos transport encoding | pass |
| C22 | admin HTTP server | real loopback listener probe | pass |
| C23 | `/healthz` | status, JSON body, and content type assertions | pass |
| C24 | `/readyz` lifecycle | false/running/stopping/stopped states asserted | pass |
| C25 | process-only readiness semantics | implementation has no dependency probe and runtime contract states the limit | pass |
| C26 | `/metrics` | Prometheus text exposition probe | pass |
| C27 | `ani_runtime_ready` gauge | gauge `0 -> 1 -> 0` asserted | pass |
| C28 | OpenTelemetry lifecycle | in-memory providers initialize and shut down through app hooks | pass |
| C29 | graceful shutdown timeout | command configured for 2 seconds exits inside 4-second outer bound and closes listener | pass |
| C30 | no business API | executable source/path scan rejects Todo and any `api/` directory | pass |
| C31 | no DB/broker/cache/provider default | direct/full module graph and denied-family scan | pass |
| C32 | empty biz/data/service seams | exact-file gate permits only `README.md` and `doc.go`; biz import test remains | pass |
| C33 | no layout runtime dependency | private layout renamed before generated service verification | pass |
| C34 | deterministic provenance | two equal inputs yield equal Git trees including modes/types | pass |
| C35 | exact ANI Go module path support | two distinct ordinary inputs plus collision-prone legal service name `go` verified | pass |
| C36 | fail-closed generation | invalid/existing/dirty/detached/tool/error/interruption/race cases | pass |
| C37 | pinned generation tools | module+version checks, observed hashes, and `@latest` rejection | pass |
| C38 | generated-code reproducibility | source Proto is normalized, pinned Buf regenerates pb.go, and rerun yields the same tree | pass |

## Components deliberately absent from LAYOUT-0

These are not silently omitted. They are service/domain or deployment choices
and therefore are not applicable to the generic shell.

| Component | LAYOUT-0 status | Reason |
| --- | --- | --- |
| registry and service discovery | not_applicable | there is no deployment topology or service-to-service endpoint yet |
| generated outbound clients | not_applicable | no external contract exists before a vertical slice |
| authentication and authorization | not_applicable | identity semantics belong to IAM and the consuming service contract |
| rate limit, retry, and circuit breaker | not_applicable | no business method or downstream dependency exists to classify |
| TLS, mTLS, and workload identity | not_applicable | production trust and certificate ownership are not frozen here |
| pprof | not_applicable | no exposure/auth policy is defined; adding it by default would create an admin surface |
| external trace/log/metric exporter | not_applicable | only local instrumentation and Prometheus exposition are proven |
| remote configuration center | not_applicable | typed file/env config is the only frozen local input |
| database, cache, queue, and worker | not_applicable | transaction, delivery, and task semantics belong to a real domain slice |
| container, Kubernetes, Helm, release | not_applicable | packaging and deployment are explicitly deferred |

No `not_applicable` row is evidence that the component will never be needed.
The owning service must introduce and test it when a concrete vertical slice
requires it.
