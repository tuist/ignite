defmodule Ignite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Run migrations before starting the application
    migrate()
    
    children = [
      IgniteWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:ignite, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ignite.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ignite.Finch},
      # Start the Ecto repository
      Ignite.Repo,
      # Start Daemon for platform-specific operations
      daemon_spec(),
      # Start to serve requests, typically the last entry
      IgniteWeb.Endpoint,
      # Start Absinthe Subscription supervision tree AFTER Endpoint
      {Absinthe.Subscription, IgniteWeb.Endpoint},
      # Launch browser after endpoint is started
      browser_launcher_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ignite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp daemon_spec do
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
    
    {Daemon, server_url: server_url, name: Ignite.Daemon}
  end

  defp browser_launcher_spec do
    # Only launch browser when configured and not in IEx
    launch_browser = Application.get_env(:ignite, :launch_browser, true)
    in_iex = Code.ensure_loaded?(IEx) and IEx.started?()
    
    if launch_browser and not in_iex do
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
  
  defp migrate do
    # Ensure the repo is started before running migrations
    {:ok, _} = Application.ensure_all_started(:ecto_sql)
    {:ok, _} = Ignite.Repo.start_link()
    
    # Run migrations
    path = Application.app_dir(:ignite, "priv/repo/migrations")
    Ecto.Migrator.run(Ignite.Repo, path, :up, all: true)
    
    # Stop the repo as it will be started again by the supervisor
    Ignite.Repo.stop()
  rescue
    error ->
      IO.puts("Warning: Could not run migrations: #{inspect(error)}")
  end
end
