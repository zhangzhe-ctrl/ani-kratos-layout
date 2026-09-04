# Upstream Generator Provenance

- Captured: 2026-09-04
- Evidence status: **pass for identity and baseline capture only**

## Generator identity

| Field | Observed value |
| --- | --- |
| CLI path | `/home/chabking/go/bin/kratos` |
| version command | `kratos -v` |
| reported version | `kratos version v3.0.0` |
| Go module | `github.com/go-kratos/kratos/cmd/kratos/v3` |
| module version | `v3.0.0-20260626125723-668db92c2c00` |
| framework commit encoded by module version | `668db92c2c001e9552594ba5a8aede8456af6d7e` |
| CLI SHA-256 | `5fa73bad7552d84712f2273c0cd4b5b8ec9b988ee69755f22a0576493b8a727c` |
| builder reported by `go version -m` | `go1.26.7-X:nodwarf5` |

The supported version flag is `-v`; `kratos version` is not a valid command for
this binary.

## Official layout identity

| Field | Observed value |
| --- | --- |
| repository | `github.com/go-kratos/kratos-layout` |
| selected ref | tag `v3.0.0` |
| commit | `94dbfcc4264a6be8e7b6c4929923c1e1f738b980` |
| tree | `5c4bc67d0dda31e60c5ef27f1bdd4551a9e8ffcc` |
| local evidence source | `/tmp/layout0-upstream-kratos-layout-v3.0.0` |
| local evidence checkout | detached at the selected commit; clean |

The moving upstream `main` revision was deliberately not used as the baseline.

## Generation event

The first direct network fetch failed with an HTTP/2 transport error. This is an
environmental/network result and is not evidence that the upstream source is
invalid. The same immutable Git object was then exposed through a local
`file://` repository and supplied to the official CLI:

```text
/home/chabking/go/bin/kratos new \
  /home/chabking/workspace/ANI/.scratch/ani-kratos-layout-layout0 \
  --repo file:///tmp/layout0-upstream-kratos-layout-v3.0.0 \
  --branch v3.0.0 \
  --timeout 120s
```

The official CLI generated 40 files. That unmodified result was committed as the
baseline described in [generated-baseline.md](generated-baseline.md).

## Observed upstream generator behavior

- `.git` and `.github` are omitted from generated output;
- the template module is rewritten to the destination basename, not to an
  arbitrary full Go module path;
- `cmd/server` is renamed to `cmd/<destination-basename>`; and
- reusing a detached-tag cache can fail when the CLI asks Git for a symbolic
  branch.

LAYOUT-0 therefore uses an ordinary clean local layout branch and a thin wrapper
for full-module replacement, CI restoration, provenance, and fail-closed output
handling. These accommodations do not replace the official generator engine.

## Reproduction limits

- The temporary evidence clone and CLI cache are not release artifacts.
- A network fetch from the public upstream was **not_verified** in the successful
  path because the successful generation used the already verified local Git
  object.
- Remote repository identity and release publication are out of scope and
  **not_verified**.
