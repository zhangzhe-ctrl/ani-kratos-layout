# LAYOUT-0 Verification Record

- Candidate commit: **not yet recorded**
- Evidence capture date: 2026-09-04
- Overall result: **not_verified**

## Result vocabulary

- `pass`: exact command and assertions were executed at the recorded candidate
  commit and evidence was retained.
- `fail`: execution completed and contradicted at least one required assertion.
- `not_verified`: execution has not occurred, evidence is missing, or the test
  does not prove the stated behavior.

Do not replace `fail` with `not_verified` when replanning. Local evidence does
not establish CI, deployment, or live external behavior.

## Provenance and baseline

| Gate | Assertion | Evidence | Status |
| --- | --- | --- | --- |
| V01 | Kratos CLI is v3.0.0 with the recorded module and SHA-256 | [upstream-provenance.md](upstream-provenance.md) | pass |
| V02 | official layout is tag v3.0.0 at the recorded commit and tree | [upstream-provenance.md](upstream-provenance.md) | pass |
| V03 | official output is preserved before ANI edits | baseline commit `4af0617138aa0fb10a4495ccd05c234da12aaf63`, [generated-baseline.md](generated-baseline.md) | pass |
| V04 | finished candidate commit is recorded and clean | pending | not_verified |
| V05 | every baseline and added path is accounted for | [scaffold-delta.md](scaffold-delta.md), final diff pending | not_verified |

## Source and generation gates

Commands below are intended to run from the clean layout candidate unless a
generated repository is named explicitly. Exact evidence paths should be added
when results exist.

| Gate | Command or procedure | Required assertion | Status |
| --- | --- | --- | --- |
| V10 | pinned Buf lint/build/generate, then `git diff --exit-code` | config generated code is reproducible | not_verified |
| V11 | `gofmt` check over tracked Go files | no formatting diff | not_verified |
| V12 | scan source/build files for `@latest`, Todo, Wire, Ent, AIP, baseline module token | no prohibited residue outside historical evidence docs | not_verified |
| V13 | inspect `go.mod` and `go list -m all` | direct graph matches dependency baseline; denied families absent | not_verified |
| V14 | generate same full module into two fresh destinations | byte-identical trees excluding `.git` and documented nondeterministic build artifacts | not_verified |
| V15 | generate a second distinct full module | module declaration, imports, service name, and command path are correct | not_verified |
| V16 | hide or rename the layout checkout, then build generated service | generated service has no layout filesystem/runtime dependency | not_verified |
| V17 | inspect generated result | layout-only wrapper/templates/evidence are absent; service README/AGENTS/provenance and CI are present | not_verified |

## Fail-closed wrapper gates

Each test uses a task-owned temporary parent and must leave no partial
destination.

| Gate | Injected condition | Required result | Status |
| --- | --- | --- | --- |
| V20 | syntactically invalid Go module path | non-zero exit; no destination | not_verified |
| V21 | destination already exists | non-zero exit; existing content unchanged | not_verified |
| V22 | layout checkout is dirty | non-zero exit; no destination | not_verified |
| V23 | layout checkout is detached or identity cannot be proven | non-zero exit; no destination | not_verified |
| V24 | Kratos CLI version/module/hash differs from the pin | non-zero exit; no destination | not_verified |
| V25 | generator prints an `ERROR:` line while returning zero | wrapper detects failure; no destination | not_verified |
| V26 | generation is interrupted before final move | only private temporary output exists and is cleaned; no destination | not_verified |

## Go and runtime gates

| Gate | Command or probe | Required assertion | Status |
| --- | --- | --- | --- |
| V30 | `go test ./...` with task-owned cache | all tests pass | not_verified |
| V31 | `go vet ./...` | no findings | not_verified |
| V32 | `go build ./cmd/...` | server binary builds | not_verified |
| V33 | `go mod verify` | every downloaded module checksum verifies | not_verified |
| V34 | start generated binary with an isolated local config | both listeners bind only requested addresses | not_verified |
| V35 | gRPC health `Check` | returns serving after startup | not_verified |
| V36 | gRPC reflection probe | reflection remains disabled | not_verified |
| V37 | `GET /healthz` | expected Kratos-encoded success | not_verified |
| V38 | `GET /readyz` before/running/stopping | state follows process lifecycle and makes no dependency claim | not_verified |
| V39 | `GET /metrics` | valid Prometheus exposition contains `ani_runtime_ready` | not_verified |
| V40 | send termination signal | process exits within configured shutdown timeout; listeners close | not_verified |
| V41 | inspect request logs and metrics | structured correlation fields and frozen middleware effects are observable | not_verified |

## Supply-chain gates

| Gate | Command or procedure | Required assertion | Status |
| --- | --- | --- | --- |
| V50 | `govulncheck ./...` with recorded DB/tool context | no untriaged reachable finding | not_verified |
| V51 | CycloneDX Go-module SBOM generation | valid SBOM attached to the candidate commit | not_verified |
| V52 | secret scan over tracked files and history introduced by LAYOUT-0 | no credential material | not_verified |
| V53 | license/notice review | upstream MIT license preserved; dependency obligations recorded | not_verified |

## Evidence outside this work package

| Claim | Status | Reason |
| --- | --- | --- |
| remote Git repository exists | not_verified | remote creation/push is not authorized |
| hosted CI passes | not_verified | no remote push or PR is in scope |
| container image builds | not_verified | packaging is deferred |
| Kubernetes deployment works | not_verified | deployment/live infrastructure is out of scope |
| any notification is submitted or delivered | not_verified | NOTIFY implementation starts only after LAYOUT-0 acceptance |
| frontend integration works | not_verified | ANI frontend is retired and excluded |
| native Go 1.25.7 gates pass | not_verified | current observed host tool reports Go 1.26.7-X:nodwarf5 |

## Acceptance checklist

- [ ] record the exact clean candidate commit;
- [ ] reconcile the complete scaffold delta;
- [ ] close every C01–C38 component row;
- [ ] retain deterministic and fail-closed generation evidence;
- [ ] retain local Go/runtime and supply-chain evidence;
- [ ] list every remaining `fail` and `not_verified` result without relabeling;
- [ ] independent review finds no undeclared scope expansion; and
- [ ] decision owner accepts L1–L4 with the phrase in `docs/LAYOUT-0.md`.

Current result: **not_verified — implementation and human acceptance remain
open**.
