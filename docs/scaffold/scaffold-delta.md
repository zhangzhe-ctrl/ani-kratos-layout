# Complete Scaffold Delta

- Comparison base: `4af0617138aa0fb10a4495ccd05c234da12aaf63`
- Target: LAYOUT-0 candidate
- Current execution state: **not_verified**

This inventory accounts for every file in the 40-file official generated
baseline and every planned LAYOUT-0 addition. “Target action” is the frozen
design; it is not evidence that the action has occurred. The final verifier must
compare the candidate revision to the baseline and update the result only after
the assertions run.

## Repository and build files

| Baseline path | Target action | Reason | Status |
| --- | --- | --- | --- |
| `.gitattributes` | rewrite | remove Wire/Ent generated-code assumptions; retain only attributes used by this layout | not_verified |
| `.gitignore` | rewrite | ignore deterministic local build, tool, cache, and temporary output | not_verified |
| `AGENTS.md` | rewrite | keep service-local, concise instructions; remove an inherited second governance system | not_verified |
| `CLAUDE.md` | delete | avoid duplicated tool-specific governance in every generated service | not_verified |
| `Dockerfile` | delete/defer | image policy and base-image lifecycle are not frozen in LAYOUT-0 | not_verified |
| `LICENSE` | preserve | retain upstream MIT license and attribution | not_verified |
| `Makefile` | rewrite | add pinned, reproducible generate/test/vet/build/verify/vulnerability/SBOM targets; remove `@latest` | not_verified |
| `README.md` | rewrite | explain layout consumption and generated-service ownership | not_verified |
| `buf.gen.config.yaml` | delete | converge on one config-generation entry point | not_verified |
| `buf.gen.yaml` | rewrite | generate only the generic typed configuration with a pinned plugin | not_verified |
| `buf.lock` | delete unless a declared remote module requires it | avoid retaining Todo-era remote dependency state | not_verified |
| `buf.yaml` | rewrite | scope lint/build to LAYOUT-0 protobuf inputs | not_verified |
| `go.mod` | rewrite | use the ANI layout module and reviewed runtime pins; remove Todo, AIP, and Wire dependencies | not_verified |
| `go.sum` | regenerate from `go.mod` | make the checksum set a consequence of the frozen dependency graph | not_verified |
| `openapi.yaml` | delete | it describes the upstream Todo API; LAYOUT-0 has no business HTTP API | not_verified |

## Upstream Todo API

All six paths are deleted because a reusable runtime template must not prescribe
a business domain:

| Baseline path | Target action | Status |
| --- | --- | --- |
| `api/todo/v1/error_reason.pb.go` | delete | not_verified |
| `api/todo/v1/error_reason.proto` | delete | not_verified |
| `api/todo/v1/todo.pb.go` | delete | not_verified |
| `api/todo/v1/todo.proto` | delete | not_verified |
| `api/todo/v1/todo_grpc.pb.go` | delete | not_verified |
| `api/todo/v1/todo_http.pb.go` | delete | not_verified |

## Composition root

| Baseline path | Target action | Status |
| --- | --- | --- |
| `cmd/ani-kratos-layout-layout0/main.go` | replace with `cmd/server/main.go` | not_verified |
| `cmd/ani-kratos-layout-layout0/wire.go` | delete; replace behavior with explicit `cmd/server/app.go` | not_verified |
| `cmd/ani-kratos-layout-layout0/wire_gen.go` | delete | not_verified |

Planned additions are `cmd/server/app.go` and `cmd/server/main_test.go`. The
generated service name and full module path are materialized by the wrapper; no
Wire generator is required.

## Configuration

| Baseline path | Target action | Status |
| --- | --- | --- |
| `configs/config.yaml` | replace Todo/data config with safe local gRPC/admin runtime defaults | not_verified |
| `internal/conf/conf.proto` | delete; replace with versioned `internal/conf/v1/conf.proto` | not_verified |
| `internal/conf/conf.pb.go` | delete; regenerate as `internal/conf/v1/conf.pb.go`; never hand-edit | not_verified |

Planned additions are `internal/conf/v1/validate.go` and
`internal/conf/v1/validate_test.go`.

## Business, data, and service seams

| Baseline path | Target action | Status |
| --- | --- | --- |
| `internal/biz/README.md` | rewrite as a short ownership/navigation note | not_verified |
| `internal/biz/biz.go` | reduce to a package declaration/doc only, if retained | not_verified |
| `internal/biz/todo.go` | delete | not_verified |
| `internal/data/README.md` | rewrite as a short ownership/navigation note | not_verified |
| `internal/data/data.go` | reduce to a package declaration/doc only, if retained | not_verified |
| `internal/data/todo.go` | delete | not_verified |
| `internal/service/README.md` | rewrite as a short ownership/navigation note | not_verified |
| `internal/service/service.go` | reduce to a package declaration/doc only, if retained | not_verified |
| `internal/service/todo.go` | delete | not_verified |
| `internal/service/todo_test.go` | delete | not_verified |

These directories are ordinary extension seams. They do not recreate ANI's
historical Core/Service import rules.

## Runtime servers

| Baseline path | Target action | Status |
| --- | --- | --- |
| `internal/server/grpc.go` | replace with the LAYOUT-0 middleware and health contract | not_verified |
| `internal/server/http.go` | replace with `internal/server/admin.go` | not_verified |
| `internal/server/server.go` | rewrite to expose explicit server composition | not_verified |

Planned additions are:

- `internal/server/admin_test.go`;
- `internal/server/observability.go`;
- `internal/server/readiness.go`; and
- focused runtime integration tests under `tests/runtime/` when the public
  process seam cannot be covered adequately inside the package.

## Layout-only additions

The following content exists in the layout repository but is removed or
rewritten appropriately in a generated service:

| Path | Purpose | Generated-service disposition | Status |
| --- | --- | --- | --- |
| `.github/workflows/ci.yml` | pinned local/CI quality gates | restored by wrapper because official CLI omits `.github` | not_verified |
| `scripts/new-service` | single thin generation entry point | omitted | not_verified |
| `templates/service/README.md` | generated-service README source | materialized as root `README.md` | not_verified |
| `templates/service/AGENTS.md` | generated-service instruction source | materialized as root `AGENTS.md` | not_verified |
| `docs/LAYOUT-0.md` | layout decision record | omitted | not_verified |
| `docs/runtime.md` | generic runtime contract | retained or linked as generated-service runtime documentation | not_verified |
| `docs/scaffold/*` | layout provenance, policy, and verification evidence | layout-only evidence omitted, except generated provenance | not_verified |
| `docs/scaffold/provenance.md` in generated output | deterministic source/module record produced by wrapper | retained | not_verified |

## Final delta gate

Before acceptance, the verifier must:

1. list every path changed since the baseline commit;
2. confirm each baseline path appears in a table above;
3. confirm every new path has a declared role and generated-service
   disposition;
4. reject undeclared business, infrastructure, provider, or deployment code;
5. reject remaining Todo, Wire, Ent, AIP, `@latest`, or baseline module-name
   artifacts; and
6. attach the exact candidate commit to [verification.md](verification.md).

Result: **not_verified**.
