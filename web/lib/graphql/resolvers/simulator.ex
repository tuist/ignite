defmodule IgniteWeb.GraphQL.Resolvers.Simulator do
  
  def list_simulators(_parent, _args, _resolution) do
    # Get simulators from Daemon
    case GenServer.call(Ignite.Daemon, :list_simulators) do
      {:ok, simulators} ->
        simulators = simulators
          |> Enum.map(fn sim ->
            %{
              id: Map.get(sim, :identifier, "unknown"),
              name: Map.get(sim, :display_name, Map.get(sim, :name, "Unknown")),
              device_type: Map.get(sim, :device, "Unknown"),
              runtime: Map.get(sim, :os, Map.get(sim, :runtime, "Unknown")),
              state: to_string(Map.get(sim, :state, "unknown")),
              is_available: Map.get(sim, :is_available, true)
            }
          end)
        {:ok, simulators}
      {:error, reason} ->
        {:error, "Failed to fetch simulators: #{inspect(reason)}"}
    end
  end
  
  def list_devices(_parent, _args, _resolution) do
    # Get devices from Daemon
    case GenServer.call(Ignite.Daemon, :list_devices) do
      {:ok, devices} ->
        devices = devices
          |> Enum.map(fn dev ->
            %{
              id: dev.identifier,
              name: dev.display_name || dev.name,
              device_type: dev.device || "Unknown",
              state: to_string(dev.state)
            }
          end)
        {:ok, devices}
      {:error, reason} ->
        {:error, "Failed to fetch devices: #{inspect(reason)}"}
    end
  end
  
  def get_build_environment_info(_parent, _args, _resolution) do
    # Get build environment info from Daemon
    case Daemon.get_build_environment_info(Ignite.Daemon) do
      {:ok, info} ->
        {:ok, %{
          local_ip: info.local_ip,
          tailscale_url: info.tailscale_url || ""
        }}
      {:error, reason} ->
        {:error, "Failed to get build environment info: #{inspect(reason)}"}
    end
  end
end