# Dependency and Toolchain Baseline

- Status: **pass on the recorded local candidate**
- Reference runtime: accepted `ani-iam` commit
  `05ba302661d593b608df070dd51cc063fc9f8023`
- Verified host: `go1.26.7-X:nodwarf5 linux/amd64`

The IAM revision is only a known-working reference for generic Kratos runtime
assembly. IAM APIs, storage, configuration, ports, metrics, and business
behavior are not copied.

## Direct runtime graph

| Module or directive | Frozen value | Verification |
| --- | --- | --- |
| Go directive | `1.26.7` | `go.mod` and generated repository |
| `github.com/go-kratos/kratos/v3` | `v3.0.0` | direct graph gate |
| `github.com/go-kratos/kratos/contrib/otel/v3` | `v3.0.0-20260515082355-1ddb58e407c5` | direct graph gate |
| `github.com/prometheus/client_golang` | `v1.24.1` | direct graph gate |
| `go.opentelemetry.io/otel` | `v1.44.0` | direct graph gate |
| `go.opentelemetry.io/otel/metric` | `v1.44.0` | direct graph gate |
| `go.opentelemetry.io/otel/sdk` | `v1.44.0` | direct graph gate |
| `go.opentelemetry.io/otel/sdk/metric` | `v1.44.0` | direct graph gate |
| `go.opentelemetry.io/otel/exporters/prometheus` | `v0.66.0` | direct graph gate |
| `go.uber.org/automaxprocs` | `v1.6.0` | direct graph gate |
| `google.golang.org/grpc` | `v1.82.1` | direct graph gate |
| `google.golang.org/protobuf` | `v1.36.11` | direct graph gate |

The executable gate compares all 11 non-main direct modules exactly, runs
`go mod tidy -diff` and `go mod verify`, and scans the complete 83-entry
module graph for denied defaults.

The official generated baseline used gRPC `v1.81.1` and OpenTelemetry
`v1.43.0`. Those revisions were previously flagged against GO-2026-6061 and
GO-2026-5158, so the candidate uses the already exercised repaired set above.
The current scan result is recorded in [verification.md](verification.md).

## Intentionally absent dependency families

| Family | Reason |
| --- | --- |
| Wire | composition is explicit Go |
| Ent, pgx, SQL drivers | persistence belongs to each service |
| AIP and Todo modules | the upstream sample domain is removed |
| NATS, Kafka, Redis | messaging/cache topology is not a layout concern |
| Kubernetes and KubeVirt clients | platform providers are not a generic service default |
| SMTP, DingTalk, Feishu, WeCom, WebSocket providers | notification delivery is outside LAYOUT-0 |
| ANI and `ani-iam` runtime modules | generated services do not couple to sibling repositories |

The full-graph gate rejects these known families. A future dependency change is
reviewed through the upgrade procedure; this list is not a substitute for that
review.

## Generation and evidence tools

| Tool | Enforced source identity | Local binary SHA-256 | Status |
| --- | --- | --- | --- |
| Kratos CLI | `github.com/go-kratos/kratos/cmd/kratos/v3@v3.0.0-20260626125723-668db92c2c00`; output `kratos version v3.0.0` | `5fa73bad7552d84712f2273c0cd4b5b8ec9b988ee69755f22a0576493b8a727c` | pass |
| Buf | `github.com/bufbuild/buf@v1.60.0` | `d931e6035fa4a101f6da4aeeeefcf72ea9478e08b6cc9a707d0e407bd5caee51` | pass |
| `protoc-gen-go` | `google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11` in `buf.gen.yaml` | executed through pinned Go module | pass |
| govulncheck | `golang.org/x/vuln@v1.7.0` | `cc939c9c2174c420e7c41f08d9e5d821ada9521a83988ddac9e5dc55c0b62a9e` | pass |
| CycloneDX GoMod | `github.com/CycloneDX/cyclonedx-gomod@v1.12.0` | `437970c07caaf3f254f19a226f2fd72d78b37ef1927e31d806d0eea2c65c48e2` | pass |
| Gitleaks | `github.com/zricethezav/gitleaks/v8@v8.30.1` | `301bf2649b8d93f0db33df6bfcb0aeb9b03783a13a3bcba34c8fffe42aed6a3b` | pass |

Module path plus version is the portable executable pin. Binary hashes are
per-execution evidence, not a false promise that separately built binaries on
other platforms have identical bytes.

## Verification boundary

- Native execution with the declared Go `1.26.7` toolchain is
  **not_verified**; the host used the recorded `go1.26.7-X:nodwarf5` variant.
- The committed SBOM is runtime-only and targets Linux/amd64. Test-only and
  alternate-platform dependency inventories are **not_verified**.
- A vulnerability result is current only for the scanner and database timestamp
  in [verification.md](verification.md).
