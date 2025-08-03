defmodule Mix.Tasks.Protobuf.Generate do
  use Mix.Task

  @shortdoc "Generate Elixir files from protobuf definitions"

  def run(_args) do
    Mix.shell().info("Generating protobuf files...")
    
    # Generate for main project
    System.cmd("protoc", [
      "--elixir_out=plugins=grpc:./lib/ignite/grpc/proto",
      "--proto_path=./priv/protos",
      "./priv/protos/sidekick.proto"
    ], into: IO.stream(:stdio, :line))
    
    # Generate for sidekick project
    System.cmd("protoc", [
      "--elixir_out=plugins=grpc:./sidekick/lib/sidekick/proto",
      "--proto_path=./sidekick/priv/protos",
      "./sidekick/priv/protos/sidekick.proto"
    ], into: IO.stream(:stdio, :line))
    
    Mix.shell().info("Protobuf files generated successfully!")
  end
end