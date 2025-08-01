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
      IgniteWeb.Endpoint,
      # Launch browser after endpoint is started
      browser_launcher_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ignite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp sidekick_spec do
    # Use the same host configuration as the Phoenix endpoint
    endpoint_config = Application.get_env(:ignite, IgniteWeb.Endpoint, [])
    
    # Get the URL configuration
    url_config = endpoint_config[:url] || []
    host = url_config[:host] || "localhost"
    
    # Get the base port from HTTP/HTTPS config
    http_config = endpoint_config[:http] || []
    https_config = endpoint_config[:https] || []
    base_port = http_config[:port] || https_config[:port] || 4000
    
    # For gRPC, we'll use the base port + 1
    grpc_port = if is_binary(base_port) do
      String.to_integer(System.get_env("PORT", "4000")) + 1
    else
      base_port + 1
    end
    
    server_url = "#{host}:#{grpc_port}"
    
    {Sidekick, server_url: server_url, name: Ignite.Sidekick}
  end

  defp browser_launcher_spec do
    # Only launch browser in development and when not in IEx
    if Application.get_env(:ignite, :launch_browser, true) and 
       Mix.env() != :test and
       !IEx.started?() do
      Ignite.BrowserLauncher
    else
      # Return a no-op child spec that immediately terminates
      %{
        id: :browser_launcher_noop,
        start: {Task, :start_link, [fn -> :ok end]},
        restart: :temporary
      }
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IgniteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
