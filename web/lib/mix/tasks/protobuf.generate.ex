defmodule Mix.Tasks.Protobuf.Generate do
  use Mix.Task

  @shortdoc "Generate Elixir files from protobuf definitions"

  def run(_args) do
    Mix.shell().info("Generating protobuf files...")
    
    # Generate for main project
    System.cmd("protoc", [
      "--elixir_out=plugins=grpc:./lib/ignite/grpc/proto",
      "--proto_path=./priv/protos",
      "./priv/protos/daemon.proto"
    ], into: IO.stream(:stdio, :line))
    
    # Generate for daemon project
    System.cmd("protoc", [
      "--elixir_out=plugins=grpc:./daemon/lib/daemon/proto",
      "--proto_path=./daemon/priv/protos",
      "./daemon/priv/protos/daemon.proto"
    ], into: IO.stream(:stdio, :line))
    
    Mix.shell().info("Protobuf files generated successfully!")
  end
end