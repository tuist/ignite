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
      # Start Sidekick for platform-specific operations
      sidekick_spec(),
      # Start to serve requests, typically the last entry
      IgniteWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ignite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp sidekick_spec do
    # Get the Sidekick server URL from config or environment
    server_url = System.get_env("SIDEKICK_URL") || 
                 Application.get_env(:ignite, :sidekick_url, "localhost:50051")
    
    {Sidekick, server_url: server_url, name: Ignite.Sidekick}
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IgniteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
