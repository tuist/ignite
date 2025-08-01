defmodule Sidekick.MixProject do
  use Mix.Project

  def project do
    [
      app: :sidekick,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Local agent for platform-specific operations in Ignite",
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # gRPC dependencies
      {:grpc, "~> 0.7"},
      {:protobuf, "~> 0.12"},
      
      # JSON handling
      {:jason, "~> 1.4"},
      
      # Development dependencies
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md", ".formatter.exs"],
      maintainers: ["Tuist Team"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/tuist/ignite"
      }
    ]
  end
end