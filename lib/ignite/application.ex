defmodule Ignite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      IgniteWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:ignite, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ignite.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ignite.Finch},
      # Start a worker by calling: Ignite.Worker.start_link(arg)
      # {Ignite.Worker, arg},
      # Start to serve requests, typically the last entry
      IgniteWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ignite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IgniteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
