# Official Generated Baseline

- Baseline commit: `4af0617138aa0fb10a4495ccd05c234da12aaf63`
- Commit subject: `chore: capture Kratos v3.0.0 generator baseline`
- Upstream layout: `v3.0.0` at
  `94dbfcc4264a6be8e7b6c4929923c1e1f738b980`
- Result: **pass — immutable local baseline captured**

The commit contains the official CLI output before ANI-specific edits: 40 files,
4,790 inserted lines.

## Anchor hashes

| File at baseline commit | SHA-256 |
| --- | --- |
| `go.mod` | `461c25ed2daca8215cb4bc7ad837cf0b67a530ad30b80a7d0f7cbacff8026801` |
| `internal/conf/conf.proto` | `f29b166e161e74705f1cb2524eae17edd0dea88d51cf7e24e451d0d31403f3c7` |
| `cmd/ani-kratos-layout-layout0/main.go` | `a169010945fc65bddf8f9e1577eb2c07c402a3134a739c80e0900d79a9259a45` |

The hashes identify the generated baseline; they are not expected to match the
finished ANI layout.

## Complete baseline manifest

```text
.gitattributes
.gitignore
AGENTS.md
CLAUDE.md
Dockerfile
LICENSE
Makefile
README.md
api/todo/v1/error_reason.pb.go
api/todo/v1/error_reason.proto
api/todo/v1/todo.pb.go
api/todo/v1/todo.proto
api/todo/v1/todo_grpc.pb.go
api/todo/v1/todo_http.pb.go
buf.gen.config.yaml
buf.gen.yaml
buf.lock
buf.yaml
cmd/ani-kratos-layout-layout0/main.go
cmd/ani-kratos-layout-layout0/wire.go
cmd/ani-kratos-layout-layout0/wire_gen.go
configs/config.yaml
go.mod
go.sum
internal/biz/README.md
internal/biz/biz.go
internal/biz/todo.go
internal/conf/conf.pb.go
internal/conf/conf.proto
internal/data/README.md
internal/data/data.go
internal/data/todo.go
internal/server/grpc.go
internal/server/http.go
internal/server/server.go
internal/service/README.md
internal/service/service.go
internal/service/todo.go
internal/service/todo_test.go
openapi.yaml
```

## Interpretation

This commit is an audit point, not an accepted service architecture. It includes
the upstream Todo example, Wire, moving `@latest` tool installs, permissive
listener defaults, and dependencies that LAYOUT-0 intentionally evaluates or
removes. See [scaffold-delta.md](scaffold-delta.md) for the exhaustive disposition.
