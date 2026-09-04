# ani-service-template

Module: `__SERVICE_MODULE__`

This repository was generated from ANI's pinned Kratos layout. It is an
independent source snapshot: builds and runtime do not require the layout.

## Local commands

```bash
make tools
make verify
go run ./cmd/ani-service-template -conf ./configs
```

The committed listeners are loopback-only local defaults. Override them through
the typed `ANI` environment configuration when the deployment design is added.

## Runtime shell

- Kratos lifecycle with graceful shutdown.
- gRPC and a separate admin HTTP server.
- Structured redacted logs, tracing, metrics, and middleware.
- `/healthz` reports process liveness.
- `/readyz` reports only completion of the local runtime start hook; add checks
  for real dependencies when the first vertical slice introduces them.
- `/metrics` exports the local Prometheus registry.

There is intentionally no sample domain, persistence, broker, auth, provider,
container, or deployment configuration.
