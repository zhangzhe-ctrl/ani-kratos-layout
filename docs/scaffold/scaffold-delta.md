# Complete Scaffold Delta

- Comparison base: `4af0617138aa0fb10a4495ccd05c234da12aaf63`
- Target identity: local tag `layout-0-candidate`
- Reconciliation result: **pass**

The base is the unmodified 40-file output of the pinned official generator.
Every base path and every LAYOUT-0-only addition is accounted for below.

## Official baseline paths

| Baseline path | Final action | Reason |
| --- | --- | --- |
| `.gitattributes` | rewrite | retain only attributes used by this layout |
| `.gitignore` | rewrite | ignore task-owned build, tool, and cache output |
| `AGENTS.md` | rewrite | concise service-local ownership rules |
| `CLAUDE.md` | delete | do not copy a second tool-specific governance system |
| `Dockerfile` | delete/defer | image policy is outside LAYOUT-0 |
| `LICENSE` | rename to `THIRD_PARTY_NOTICES.go-kratos-layout.txt` | retain upstream MIT notice without selecting a license for ANI-authored or generated-service code |
| `Makefile` | rewrite | pinned generate/test/vet/build/vulnerability/SBOM gates |
| `README.md` | rewrite | layout interface, ownership, and limits |
| `buf.gen.config.yaml` | delete | one config-generation entry point |
| `buf.gen.yaml` | rewrite | pinned typed-config generator only |
| `buf.lock` | delete | no remote Buf module remains |
| `buf.yaml` | rewrite | only `internal/` typed config input |
| `go.mod` | rewrite | reviewed Kratos runtime graph; no sample domain/DI stack |
| `go.sum` | regenerate | checksum consequence of the frozen graph |
| `openapi.yaml` | delete | it described the Todo sample |

All six `api/todo/v1/*` files are deleted. LAYOUT-0 defines no business API.

| Baseline path | Final action |
| --- | --- |
| `api/todo/v1/error_reason.pb.go` | delete |
| `api/todo/v1/error_reason.proto` | delete |
| `api/todo/v1/todo.pb.go` | delete |
| `api/todo/v1/todo.proto` | delete |
| `api/todo/v1/todo_grpc.pb.go` | delete |
| `api/todo/v1/todo_http.pb.go` | delete |

| Baseline composition/config path | Final action |
| --- | --- |
| `cmd/ani-kratos-layout-layout0/main.go` | replace with `cmd/server/main.go` plus explicit `app.go` |
| `cmd/ani-kratos-layout-layout0/wire.go` | delete |
| `cmd/ani-kratos-layout-layout0/wire_gen.go` | delete |
| `configs/config.yaml` | replace sample/data settings with safe local runtime defaults |
| `internal/conf/conf.proto` | replace with versioned `internal/conf/v1/conf.proto` |
| `internal/conf/conf.pb.go` | replace with pinned generated `internal/conf/v1/conf.pb.go` |

| Baseline seam path | Final action |
| --- | --- |
| `internal/biz/README.md` | preserve minimal navigation heading |
| `internal/biz/biz.go` | replace with package-only `doc.go` |
| `internal/biz/todo.go` | delete |
| `internal/data/README.md` | preserve minimal navigation heading |
| `internal/data/data.go` | replace with package-only `doc.go` |
| `internal/data/todo.go` | delete |
| `internal/service/README.md` | preserve minimal navigation heading |
| `internal/service/service.go` | replace with package-only `doc.go` |
| `internal/service/todo.go` | delete |
| `internal/service/todo_test.go` | delete |

| Baseline server path | Final action |
| --- | --- |
| `internal/server/grpc.go` | replace with frozen middleware, health, and reflection-disabled construction |
| `internal/server/http.go` | replace with `internal/server/admin.go` |
| `internal/server/server.go` | reduce to package ownership documentation |

## Candidate-only paths

| Added path | Role | Generated-service disposition |
| --- | --- | --- |
| `.github/workflows/ci.yml` | source/runtime/supply-chain gates | retain |
| `.github/workflows/layout.yml` | layout generator black-box gate | omit |
| `THIRD_PARTY_NOTICES.go-kratos-layout.txt` | upstream MIT notice | retain |
| `cmd/server/app.go` | explicit production composition root | rename directory and retain |
| `cmd/server/app_test.go` | production composition/listener test | rename directory and retain |
| `cmd/server/main.go` | command/config/logger/process entry | rename directory and retain |
| `cmd/server/main_test.go` | logger and independent process/signal tests | rename directory and retain |
| `docs/LAYOUT-0.md` | layout decision record | omit |
| `docs/runtime.md` | generic runtime contract | retain |
| `docs/runtime-verification.md` | generated-service gate instructions | retain |
| `docs/scaffold/bom.cdx.json` | candidate runtime SBOM | omit; each service generates its own |
| `docs/scaffold/component-coverage.md` | candidate component evidence | omit |
| `docs/scaffold/dependency-baseline.md` | candidate dependency/tool evidence | omit |
| `docs/scaffold/generated-baseline.md` | official baseline evidence | omit |
| `docs/scaffold/license-review.md` | candidate license inventory | omit |
| `docs/scaffold/scaffold-delta.md` | this reconciliation | omit |
| `docs/scaffold/upgrade-policy.md` | layout maintenance policy | omit |
| `docs/scaffold/upstream-provenance.md` | official source identity | omit |
| `docs/scaffold/verification.md` | candidate acceptance evidence | omit |
| `internal/biz/doc.go` | empty domain seam | retain |
| `internal/conf/v1/conf.proto` | typed runtime config source | module-normalize, regenerate, retain |
| `internal/conf/v1/conf.pb.go` | generated typed config | regenerate, retain |
| `internal/conf/v1/validate.go` | listener/duration validation | retain |
| `internal/conf/v1/validate_test.go` | validation matrix | retain |
| `internal/data/doc.go` | empty outbound-adapter seam | retain |
| `internal/server/admin.go` | Kratos admin transport | retain |
| `internal/server/admin_test.go` | admin codec/middleware tests | retain |
| `internal/server/observability.go` | local OTel/Prometheus wiring | retain |
| `internal/server/readiness.go` | process-only readiness state | retain |
| `internal/service/doc.go` | empty inbound-adapter seam | retain |
| `scripts/check-generator-result` | official CLI error adapter | omit |
| `scripts/generate-sbom` | deterministic service SBOM command | retain |
| `scripts/new-service` | single layout bootstrap interface | omit |
| `scripts/verify-layout` | layout-only black-box/negative gate | omit |
| `scripts/verify-source` | generated-code and format gate | retain |
| `scripts/verify-supply-chain` | BOM/license-evidence and upstream-notice integrity gate | retain |
| `templates/service/AGENTS.md` | generated root instructions | materialize as `AGENTS.md`, then omit templates |
| `templates/service/README.md` | generated root README | materialize as `README.md`, then omit templates |
| `tests/runtime/runtime_test.go` | transport/middleware/lifecycle integration fixture | retain |

## Executed reconciliation

The final gate lists `git diff --name-status` from the base to the candidate,
checks every active source/build path for removed families, requires exactly
`README.md` and `doc.go` in each empty extension seam, and generates two equal,
one distinct, one standard-library-collision, and four identity/sample-like
edge-name services.

Generated services contain neither `templates/` nor layout evidence. They
receive a newly initialized Git repository with no remote, no submodule,
`go.work`, local `replace`, layout import, or template origin. The private
layout checkout is then renamed before the generated project is built and
tested.

Result: **pass**.
