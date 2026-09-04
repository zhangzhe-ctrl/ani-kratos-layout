# Runtime verification

The generated service keeps executable runtime checks beside the source. From a
clean checkout, run:

```bash
make tools
make verify
```

`make verify` checks that typed configuration regenerates without a content
change, rejects stale formatting or module metadata, and runs `go test`,
`go vet`, `go build`, and `go mod verify`.

The runtime integration tests start real loopback gRPC and admin HTTP listeners.
They check gRPC health, disabled reflection, health/readiness/metrics responses,
Kratos error encoding, middleware recovery/metadata/validation, request metrics,
trace-correlated structured logging, and graceful application stop. These tests
prove only the generic local runtime. They do not prove a database, broker,
provider, external telemetry backend, container, Kubernetes deployment, or
business contract.

For a current dependency scan and deterministic CycloneDX JSON SBOM:

```bash
make supply-chain-tools
make vuln
make sbom
```

Vulnerability results are valid only for the scanner and database state at the
time of execution. The SBOM generator requires a clean committed revision and
exports that revision without `.git`, preventing the main component version
from becoming a self-referential commit value.
