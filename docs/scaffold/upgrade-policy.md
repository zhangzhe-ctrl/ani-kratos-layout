# Layout and Dependency Upgrade Policy

- Status: **FROZEN POLICY — execution not_verified**

This policy keeps the layout useful without turning it into a central runtime
release train. It applies to the layout repository itself; generated services
adopt changes explicitly.

## Core rule

A generator upgrade, layout change, or dependency bump is a source change with
reviewed evidence. It is never an automatic rewrite of existing services.

## Pinning rules

1. The Kratos CLI is identified by version, Go module version, and binary hash.
2. The official layout is identified by immutable commit and tree, even when a
   human-friendly tag is also recorded.
3. Go direct dependencies use exact versions in `go.mod`.
4. Code-generation and evidence tools use exact versions. Build files must not
   install `@latest`.
5. Generated output is committed and must reproduce without a diff.
6. A mutable branch name or sibling working tree is not an acceptable release
   baseline.

## Change classes

| Class | Examples | Required review |
| --- | --- | --- |
| P0 security | exploitable runtime advisory, compromised tool/source | focused emergency upgrade, vulnerability evidence, full local gate, explicit downstream impact list |
| P1 contract | Kratos major/minor behavior, config schema, middleware order, endpoint semantics, generator behavior | design record, baseline regeneration, runtime probes, deterministic generation, generated-service compatibility review |
| P2 dependency | patch/minor runtime library or tool version | changelog/advisory review, tidy/verify, tests, vet, build, vulnerability scan, SBOM |
| P3 documentation | wording that does not change generated output or runtime semantics | link/content checks and normal review |

A nominal patch bump is promoted to P1 if it changes generated files, public
configuration, middleware order, endpoint behavior, lifecycle, or the wrapper
contract.

## Upgrade procedure

1. Create a branch from a clean, identified layout commit.
2. Record old and proposed generator/layout/dependency identities.
3. Capture a fresh unmodified official generated baseline when the generator or
   official layout changes.
4. Review the full upstream-to-ANI delta; do not carry changes through an opaque
   copy operation.
5. Run generation twice with the same module and once with a different module.
6. Exercise invalid module, existing destination, dirty layout, tool mismatch,
   and generator-failure paths.
7. Run generate-diff, format, tests, vet, build, module verification, runtime
   probes, vulnerability scan, secret scan, license check, and SBOM generation.
8. Build a generated service after making the layout checkout unavailable to
   prove independence.
9. Record the exact candidate commit and evidence in `verification.md`.
10. Obtain human acceptance before publishing or using the changed layout for a
    new service.

## Existing generated services

Existing services do not track this repository as a Go dependency, Git
submodule, vendored runtime, or startup dependency. When a service wants a
layout improvement:

1. compare the relevant layout release to the service's recorded provenance;
2. select only applicable source changes;
3. preserve the service's domain decisions;
4. run that service's own gates; and
5. merge through an ordinary service review.

There is no global “sync layout” command. A service may legitimately remain on
an older snapshot when its owners have assessed and accepted the risk.

## Emergency handling

A security emergency may shorten review latency but may not erase provenance,
hide failed gates, auto-modify unrelated services, or broaden authorization to
remote publication or deployment. Any skipped gate remains `not_verified` and
must be named explicitly.

## Rollback

Because generated services own their source, rolling back a layout release does
not mutate them. Revert the layout change through Git, retain the failed
evidence, and generate into a new temporary destination to prove the restored
revision. Never overwrite a service repository to simulate rollback.
