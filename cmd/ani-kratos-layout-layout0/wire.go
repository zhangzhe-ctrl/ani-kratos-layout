//go:build wireinject
// +build wireinject

// The build tag makes sure the stub is not built in the final build.

package main

import (
	"log/slog"

	"ani-kratos-layout-layout0/internal/biz"
	"ani-kratos-layout-layout0/internal/conf"
	"ani-kratos-layout-layout0/internal/data"
	"ani-kratos-layout-layout0/internal/server"
	"ani-kratos-layout-layout0/internal/service"

	"github.com/go-kratos/kratos/v3"
	"github.com/google/wire"
)

// wireApp init kratos application.
func wireApp(*conf.Server, *conf.Data, *slog.Logger) (*kratos.App, func(), error) {
	panic(wire.Build(server.ProviderSet, data.ProviderSet, biz.ProviderSet, service.ProviderSet, newApp))
}
