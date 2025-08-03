defmodule Ignite.GRPC.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger
  intercept Ignite.GRPC.AuthInterceptor
  run Ignite.GRPC.Server
end