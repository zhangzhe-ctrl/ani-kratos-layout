# Dependency and Toolchain Baseline

- Status: **target pins frozen; final graph verification pending**
- Reference runtime: accepted `ani-iam` commit
  `05ba302661d593b608df070dd51cc063fc9f8023`

The reference commit is used only as evidence for a known-working generic
Kratos runtime assembly. IAM-specific APIs, configuration, ports, metrics,
storage, and business behavior are excluded.

## Runtime target pins

| Module or directive | LAYOUT-0 target | Source of target | Current candidate verification |
| --- | --- | --- | --- |
| Go directive | `1.25.7` | accepted runtime reference | not_verified |
| `github.com/go-kratos/kratos/v3` | `v3.0.0` | official v3 baseline and accepted runtime reference | not_verified |
| `github.com/go-kratos/kratos/contrib/otel/v3` | `v3.0.0-20260515082355-1ddb58e407c5` | accepted runtime reference | not_verified |
| `github.com/prometheus/client_golang` | `v1.24.1` | accepted runtime reference | not_verified |
| `go.opentelemetry.io/otel` | `v1.44.0` | accepted runtime reference | not_verified |
| `go.opentelemetry.io/otel/metric` | `v1.44.0` | accepted runtime reference | not_verified |
| `go.opentelemetry.io/otel/sdk` | `v1.44.0` | accepted runtime reference | not_verified |
| `go.opentelemetry.io/otel/sdk/metric` | `v1.44.0` | accepted runtime reference | not_verified |
| `go.opentelemetry.io/otel/exporters/prometheus` | `v0.66.0` | accepted runtime reference | not_verified |
| `go.uber.org/automaxprocs` | `v1.6.0` | official baseline and accepted runtime reference | not_verified |
| `google.golang.org/grpc` | `v1.82.1` | accepted runtime reference | not_verified |
| `google.golang.org/protobuf` | `v1.36.11` | accepted runtime reference | not_verified |

The official generated baseline used gRPC `v1.81.1` and OpenTelemetry
`v1.43.0`. Preliminary dependency inventory flagged those revisions against
GO-2026-6061 and GO-2026-5158 respectively, so the LAYOUT-0 target adopts the
already exercised newer reference set. The final vulnerability scan is still
**not_verified** and may reveal additional findings.

## Intentionally absent direct dependencies

| Dependency family | Reason |
| --- | --- |
| Wire | explicit composition is the LAYOUT-0 contract |
| Ent or SQL drivers | persistence belongs to each service |
| AIP/Todo modules | upstream sample domain is removed |
| NATS, Kafka, Redis | messaging/cache topology is not a layout concern |
| Kubernetes or KubeVirt clients | platform workloads are not a generic service default |
| mail, DingTalk, Feishu, WeCom, or WebSocket providers | notification delivery is outside LAYOUT-0 |
| ANI or `ani-iam` runtime modules | generated services must not couple to sibling repositories |

Absence from this table is a target assertion; the final `go.mod` and full
transitive graph must still be inspected.

## Generation and evidence tools

| Tool | Target or observed version | Use | Status |
| --- | --- | --- | --- |
| Kratos CLI | `v3.0.0`; binary hash in `upstream-provenance.md` | official generation engine | pass for baseline event |
| Buf | `v1.60.0` | lint/build/generate typed config | not_verified |
| `protoc-gen-go` | `v1.36.11` | deterministic config protobuf generation | not_verified |
| `govulncheck` | `v1.7.0` | Go vulnerability scan | not_verified |
| `cyclonedx-gomod` | `v1.12.0` | CycloneDX SBOM | not_verified |

The host currently reports `go1.26.7-X:nodwarf5`; executing all gates with a
native Go `1.25.7` toolchain is **not_verified**. Host binaries or cached module
sources do not become proof until the recorded gate invokes them successfully.

## Baseline closure gate

The dependency baseline becomes `pass` only when all of the following evidence
is attached to one candidate commit:

1. `go mod tidy` produces the reviewed direct dependency set;
2. `go mod verify` succeeds;
3. `go list -m all` is retained and reviewed for denied families;
4. source and build files contain no moving `@latest` installations;
5. generated protobuf output is reproducible with the pinned toolchain;
6. `govulncheck ./...` has a recorded result and triage for every finding; and
7. an SBOM is generated from the same commit.

Current result: **not_verified**.
