# Repository guidance

This repository owns a build-time Kratos layout, not a shared runtime library.
Keep `scripts/new-service` as the single, thin bootstrap interface around the
pinned official `kratos new` command.

## Invariants

- Generated services must be independent source snapshots.
- Never add a Go import, `replace`, submodule, or runtime fetch back to this
  repository.
- Keep the template business-neutral. Add no example entity, database, broker,
  auth, provider, or deployment stack.
- Prefer Kratos and established Go facilities over custom lifecycle, config,
  transport, middleware, logging, tracing, metrics, or DI frameworks.
- `internal/biz` remains independent of Kratos, protobuf, transport, and
  storage drivers.
- `cmd` is the explicit composition root; `internal/service` and
  `internal/data` are adapters added only by a concrete vertical slice.
- Generated protobuf files are changed only through the pinned generator.
- A layout upgrade requires a new baseline, explicit delta, generation smoke
  tests, runtime gates, and human review. It never rewrites existing services
  automatically.

Run `make verify` before committing. Do not claim remote CI, deployment, or
external integration evidence from local checks.
