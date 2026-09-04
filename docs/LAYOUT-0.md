# LAYOUT-0 — Kratos Service Layout Freeze

- Status: **CANDIDATE — human acceptance pending**
- Date: 2026-09-04
- Decision owner: ANI maintainers
- Acceptance phrase: `接受 LAYOUT-0 的 L1–L4，开始实例化 ani-notification-service。`

This document freezes the boundary of the reusable ANI service layout before any
notification-domain implementation starts. It is a build-time scaffold, not a
runtime platform dependency.

## Decisions

### L1 — Standalone build-time layout

`ani-kratos-layout` is an independent Git repository derived from the official
Go-Kratos v3 layout. A service consumes it only while the service repository is
created. The layout does not become an imported Go module, sidecar, control
plane, or deployment-time dependency.

### L2 — One thin generation entry point

`scripts/new-service` is the single supported entry point. It invokes the pinned
official `kratos new` CLI and only fills gaps required for an auditable ANI
service creation flow:

1. validate an exact ANI Go module path of the form
   `github.com/zhangzhe-ctrl/<lowercase-service-name>` and refuse an existing
   target;
2. require the layout checkout and generator identity expected by this release;
3. generate in a private temporary directory and fail closed on CLI errors;
4. convert the generated basename module to the requested ANI module path and
   regenerate typed configuration with the pinned Buf/Protobuf pipeline;
5. restore repository files intentionally omitted by `kratos new`, including CI;
6. write deterministic generation provenance; and
7. use a no-clobber, no-target-directory move and verify ownership before
   reporting successful materialization.

The wrapper must not grow into a second framework, dependency manager, domain
generator, deployment system, or policy engine.

### L3 — Generated services own their source

After generation, each service owns a source snapshot and can build without the
layout repository. There is no automatic synchronization and no shared ANI
runtime package. Improvements to the layout reach an existing service only
through an explicit, reviewable service change.

### L4 — Generic runtime shell only

The first layout release provides only a generic local runtime shell:

- typed file and environment configuration;
- explicit application composition and lifecycle;
- structured logging and trace correlation;
- a gRPC server with standard health support;
- an administrative HTTP server for health, readiness, and metrics;
- recovery, metadata, tracing, logging, metrics, and validation middleware;
- OpenTelemetry and Prometheus integration seams;
- graceful startup and shutdown; and
- local tests and reproducible repository gates.

It contains no business API, database, queue, cache, identity policy, provider,
Kubernetes client, notification channel, or deployment opinion.

## In scope

- preserve immutable provenance for the official generator and upstream layout;
- record an exact generated baseline before ANI changes;
- replace sample application code with the generic runtime shell in L4;
- provide deterministic, fail-closed service generation;
- pin build and generation tooling rather than using moving `@latest` versions;
- document component ownership, upgrade policy, and verification evidence; and
- prove a generated repository is independent from the layout at build time.

## Explicitly denied or deferred

- notification-domain contracts or implementation, including email;
- WebSocket, terminal, Pod exec, VM, VNC, or `ani-session-gateway` changes;
- IAM, permission, quota, reservation, metering, or audit business behavior;
- importing or copying retired ANI mail implementations;
- database, RLS, NATS, Kafka, Redis, provider SDK, or task-worker defaults;
- Console or any other frontend validation;
- Kubernetes manifests, Helm, image publication, deployment, or live integration;
- changes to ANI or `ani-iam` application source;
- creating a remote repository, pushing, opening a PR, or publishing a release;
- a shared runtime library that couples generated services back to this layout;
- accepting a breaking public contract; and
- instantiating `ani-notification-service` before the human gate below.

## Frozen invariants

1. The official CLI remains the generator engine; ANI owns only the thin wrapper
   and layout contents.
2. Generator, Buf, upstream layout, Go module dependencies, and generation
   plugins are pinned to auditable source versions or immutable commits;
   platform-specific binary hashes are recorded as evidence.
3. Generation never overwrites an existing destination and never leaves a
   partially generated destination on failure.
4. A generated service has no Go, filesystem, or runtime dependency on
   `ani-kratos-layout`.
5. Runtime assembly is explicit Go code. Wire is intentionally absent from this
   first layout so dependency injection remains visible at the composition root.
6. Readiness represents only the generic process lifecycle. A generated service
   must explicitly add and test readiness for dependencies that it owns.
7. Business APIs and adapters are created by the service, not guessed by the
   layout.
8. Template upgrades never rewrite generated services automatically.
9. The upstream MIT notice is preserved, but the layout does not silently pick
   a project license for ANI-authored code or a generated service.

## Evidence model

- `pass`: the documented command ran against the recorded revision and its
  expected assertion was observed.
- `fail`: the command ran and contradicted the expected assertion.
- `not_verified`: the gate has not run, the result was not retained, or the
  evidence is insufficient. A design statement is never a `pass` by itself.

Current evidence is indexed in [scaffold/verification.md](scaffold/verification.md).
The runtime target is defined in [runtime.md](runtime.md), and the complete
upstream-to-ANI change inventory is in
[scaffold/scaffold-delta.md](scaffold/scaffold-delta.md).

## Human gate

LAYOUT-0 is not accepted merely because local tests pass. The work stops after
the candidate repository and evidence are presented. Instantiation of
`ani-notification-service` starts only after the decision owner sends exactly:

> 接受 LAYOUT-0 的 L1–L4，开始实例化 ani-notification-service。

Current result: **not_verified — acceptance has not yet been given**.
