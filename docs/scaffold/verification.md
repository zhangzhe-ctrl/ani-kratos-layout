# LAYOUT-0 Verification Record

- Evidence capture date: 2026-09-04
- Candidate identity: local annotated tag `layout-0-candidate` plus the exact SHA
  printed in the handoff; no remote identity is claimed
- Local technical result: **pass**
- Human acceptance: **not_verified**

## Result vocabulary

- `pass`: the command and its assertions ran against the candidate revision and
  the result is summarized below.
- `fail`: execution contradicted a required assertion.
- `not_verified`: the gate did not run or the evidence is insufficient.

Local evidence does not establish hosted CI, deployment, or external service
behavior. A design statement is not execution evidence.

## Execution environment

| Item | Observed identity |
| --- | --- |
| host toolchain | `go1.26.7-X:nodwarf5 linux/amd64` |
| Kratos CLI | `kratos version v3.0.0`; module `github.com/go-kratos/kratos/cmd/kratos/v3@v3.0.0-20260626125723-668db92c2c00`; SHA-256 `5fa73bad7552d84712f2273c0cd4b5b8ec9b988ee69755f22a0576493b8a727c` |
| Buf | `v1.60.0`; module `github.com/bufbuild/buf@v1.60.0`; SHA-256 `d931e6035fa4a101f6da4aeeeefcf72ea9478e08b6cc9a707d0e407bd5caee51` |
| govulncheck | `v1.7.0`; SHA-256 `cc939c9c2174c420e7c41f08d9e5d821ada9521a83988ddac9e5dc55c0b62a9e` |
| CycloneDX GoMod | `v1.12.0`; SHA-256 `437970c07caaf3f254f19a226f2fd72d78b37ef1927e31d806d0eea2c65c48e2` |
| Gitleaks | module `github.com/zricethezav/gitleaks/v8@v8.30.1`; SHA-256 `301bf2649b8d93f0db33df6bfcb0aeb9b03783a13a3bcba34c8fffe42aed6a3b` |

Kratos and Buf enforce source module plus version. Binary hashes are retained as
per-execution provenance because a valid binary hash changes with Go builder,
GOOS, and GOARCH; a single Linux hash is not presented as a cross-platform pin.

## Provenance and baseline

| Gate | Assertion and evidence | Status |
| --- | --- | --- |
| V01 | Kratos CLI source identity and observed binary hash match [upstream-provenance.md](upstream-provenance.md) | pass |
| V02 | official layout is tag `v3.0.0`, commit `94dbfcc4264a6be8e7b6c4929923c1e1f738b980`, tree `5c4bc67d0dda31e60c5ef27f1bdd4551a9e8ffcc` | pass |
| V03 | unmodified 40-file output is retained at baseline commit `4af0617138aa0fb10a4495ccd05c234da12aaf63`; all three anchor hashes were recomputed from Git objects | pass |
| V04 | candidate is a clean commit identified by local tag `layout-0-candidate`; exact SHA is reported at handoff | pass |
| V05 | every baseline path and every candidate addition is reconciled in [scaffold-delta.md](scaffold-delta.md) | pass |

## Source and generation gates

The source gate was run as:

```bash
make verify
```

The black-box layout gate was run as:

```bash
scripts/verify-layout /home/chabking/go/bin/kratos .tools/bin/buf
```

| Gate | Observed assertion | Status |
| --- | --- | --- |
| V10 | pinned Buf lint/build/generate plus `go generate` produced no tree change | pass |
| V11 | all Go source passed the all-tree `gofmt` check | pass |
| V12 | executable policy scan found no moving `@latest`, Todo, Wire, Ent, AIP, business API, workspace, submodule, or replace residue in active source/build paths | pass |
| V13 | `go mod tidy -diff`, `go mod verify`, the 11-entry direct graph, and the denied-family scan matched [dependency-baseline.md](dependency-baseline.md) | pass |
| V14 | two equal module inputs produced equal Git tree IDs, including file modes and object types | pass |
| V15 | a second exact-form ANI module produced the expected module, imports, Proto option, command directory, README, CI, and provenance; collision-prone legal service name `go` preserved `go/parser` and `go/token` while normalizing owned imports | pass |
| V16 | the private layout checkout was renamed out of reach before the generated service ran `make verify`; it still passed | pass |
| V17 | generated repositories retained service README/AGENTS/runtime docs/CI/provenance and supply-chain verification, while omitting the layout-only wrapper, templates, evidence, and workflow | pass |

The gate intentionally regenerates Protobuf after module normalization. This
prevents a text replacement from corrupting the encoded raw descriptor while
still requiring a clean regeneration on the generated service.

## Fail-closed wrapper gates

All cases used task-owned temporary parents and checked destination/cache
cleanup.

| Gate | Injected condition and observed result | Status |
| --- | --- | --- |
| V20 | three invalid module forms returned non-zero and left no destination | pass |
| V21 | an existing destination returned non-zero; its sentinel hash and sole-file shape were unchanged | pass |
| V22 | a dirty private layout returned non-zero and left no destination | pass |
| V23 | a detached private layout returned non-zero and left no destination | pass |
| V24 | mismatched Kratos and Buf version/module identities returned non-zero; binary hashes were recorded, not treated as portable pins | pass |
| V25 | an ANSI `ERROR:` helper fixture failed; a full-wrapper diagnostic injection also failed before destination materialization | pass |
| V26 | a process-group interruption during the private source clone returned non-zero and removed both scratch and private Kratos cache | pass |
| V27 | a destination created immediately before the final move was preserved unchanged; no generated files were nested into or substituted for it | pass |

## Go and runtime gates

`make verify` ran `go test -count=1 ./...`, `go vet ./...`,
`go build -trimpath ./...`, `go mod verify`, and `git diff --check`.

| Gate | Observed assertion | Status |
| --- | --- | --- |
| V30 | all seven root packages built and all tests passed | pass |
| V31 | `go vet ./...` emitted no finding | pass |
| V32 | `go build -trimpath ./...` succeeded | pass |
| V33 | module verification reported `all modules verified` | pass |
| V34 | the test built and started the real generated command on isolated loopback listeners | pass |
| V35 | gRPC health returned `SERVING` after startup | pass |
| V36 | the reflection probe returned `Unimplemented` | pass |
| V37 | `/healthz` returned Kratos-encoded JSON success | pass |
| V38 | `/readyz` and `ani_runtime_ready` were verified at false, running, stopping, and stopped lifecycle states | pass |
| V39 | `/metrics` returned Prometheus exposition and Kratos request counters | pass |
| V40 | the independent process handled an interrupt, exited successfully inside the configured bound, and closed its listener | pass |
| V41 | JSON logs contained timestamp, caller, service id/name/version, trace/span correlation, middleware request records, and redaction | pass |
| V42 | test-only gRPC RPCs proved metadata, validation-before-handler, recovery, tracing, logging, and metrics execution | pass |

## Supply-chain gates

```bash
make audit
make sbom
```

The second SBOM run was repeated with `TMPDIR` nested inside an unrelated Git
repository. All runs produced the same source-snapshot identity and bytes when
using the recorded CycloneDX binary and Linux/amd64 target.

| Gate | Observed assertion | Status |
| --- | --- | --- |
| V50 | govulncheck DB `https://vuln.go.dev`, updated `2026-09-02 19:12:04 +0000 UTC`; 7 packages and 35 modules/standard library scanned; `No vulnerabilities found.` | pass |
| V51 | [bom.cdx.json](bom.cdx.json) is CycloneDX 1.6, timestamp/serial-free, Linux/amd64 runtime scope, 34 third-party components; identical reruns use a deterministic synthetic source commit that excludes the BOM itself | pass |
| V52 | pinned Gitleaks `v8.30.1` ran `gitleaks git --no-banner --no-color --redact --log-opts="--all" .` with its embedded detector set over every local Git ref and commit; it reported `no leaks found` | pass |
| V53 | `scripts/verify-supply-chain` fixed the upstream notice SHA-256, required license evidence for all 34 runtime components, and proved the counts in [license-review.md](license-review.md) match the BOM | pass |
| V54 | a newly generated service was committed, passed `make audit`, committed its own BOM, then passed the same audit again with zero BOM drift | pass |

CycloneDX license detection is evidence, not a legal assertion. Test-only
dependencies are not included in this runtime SBOM. Publication packaging and
the license for ANI-authored code remain explicit owner decisions.

## Deliberate `not_verified` results

| Claim | Status | Reason |
| --- | --- | --- |
| human acceptance of L1-L4 | not_verified | only the decision owner can send the acceptance phrase |
| remote repository, push, branch protection, release, hosted Actions | not_verified | no remote write or hosted run is authorized |
| native Go 1.25.7, race, fuzz, other OS/architecture | not_verified | this evidence used the recorded host and Linux/amd64 target |
| container image or Kubernetes deployment | not_verified | packaging and deployment are deferred |
| external OTel collector, logs backend, dashboards, alerts | not_verified | local instrumentation does not prove external export |
| notification submission or delivery | not_verified | notification implementation starts only after acceptance |
| PostgreSQL, SMTP, NATS, IAM, key systems | not_verified | no vertical-slice integration is in LAYOUT-0 |
| distribution-license packaging or ANI project license | not_verified | requires the service/repository owner's publication decision |

## Acceptance checklist

- [x] preserve exact upstream identity and unmodified baseline;
- [x] reconcile the complete scaffold delta;
- [x] close every C01-C38 component row;
- [x] retain deterministic, fail-closed, race, and interruption generation evidence;
- [x] retain source, independent-process, vulnerability, SBOM, secret, and license-inventory evidence;
- [x] independent reviews found and the implementation closed all technical blockers;
- [ ] decision owner accepts L1-L4 with the phrase in `docs/LAYOUT-0.md`.

Current result: **local technical pass; human acceptance not_verified**.
