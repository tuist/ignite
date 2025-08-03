defmodule Sidekick do
  @moduledoc """
  Sidekick is a long-running application that establishes a gRPC connection
  to handle platform-specific operations on macOS.
  
  It acts as a bridge between the Phoenix web application and the local
  Swift agent that manages Xcode, simulators, and other native tooling.
  """

  use GenServer
  require Logger

  defstruct [:channel, :server_url, :name, :reconnect_timer]

  @reconnect_interval 5_000 # 5 seconds

  @doc """
  Starts the Sidekick service and establishes gRPC connection.
  
  Options:
    * `:server_url` - The gRPC server URL (required)
    * `:name` - The name to register the process as (optional)
  """
  def start_link(opts) do
    server_url = Keyword.fetch!(opts, :server_url)
    name = Keyword.get(opts, :name, __MODULE__)
    
    GenServer.start_link(__MODULE__, %{server_url: server_url, name: name}, name: name)
  end

  @doc """
  Child spec for supervision tree.
  """
  def child_spec(opts) do
    %{
      id: Keyword.get(opts, :name, __MODULE__),
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent
    }
  end

  ## Client API

  @doc """
  Lists available iOS simulators.
  """
  def list_simulators(sidekick \\ __MODULE__) do
    GenServer.call(sidekick, :list_simulators)
  end

  @doc """
  Boots a simulator by its identifier.
  """
  def boot_simulator(identifier, sidekick \\ __MODULE__) do
    GenServer.call(sidekick, {:boot_simulator, identifier})
  end

  @doc """
  Shuts down a simulator by its identifier.
  """
  def shutdown_simulator(identifier, sidekick \\ __MODULE__) do
    GenServer.call(sidekick, {:shutdown_simulator, identifier})
  end

  @doc """
  Compiles an Xcode project.
  """
  def compile_project(opts, sidekick \\ __MODULE__) do
    GenServer.call(sidekick, {:compile_project, opts}, :infinity)
  end

  @doc """
  Runs tests for an Xcode project.
  """
  def run_tests(opts, sidekick \\ __MODULE__) do
    GenServer.call(sidekick, {:run_tests, opts}, :infinity)
  end

  @doc """
  Lists available devices (physical iOS devices).
  """
  def list_devices(sidekick \\ __MODULE__) do
    GenServer.call(sidekick, :list_devices)
  end

  @doc """
  Gets the Xcode version.
  """
  def xcode_version(sidekick \\ __MODULE__) do
    GenServer.call(sidekick, :xcode_version)
  end

  @doc """
  Checks if the Sidekick agent is healthy and responding.
  """
  def health_check(sidekick \\ __MODULE__) do
    GenServer.call(sidekick, :health_check)
  end

  ## GenServer Callbacks

  @impl true
  def init(%{server_url: server_url, name: name}) do
    Logger.info("Starting Sidekick, connecting to #{server_url}")
    
    # Start connection process
    state = %__MODULE__{
      server_url: server_url,
      name: name,
      channel: nil
    }
    
    {:ok, state, {:continue, :connect}}
  end

  @impl true
  def handle_continue(:connect, state) do
    case establish_connection(state.server_url) do
      {:ok, channel} ->
        Logger.info("Successfully connected to Sidekick agent at #{state.server_url}")
        {:noreply, %{state | channel: channel}}
        
      {:error, reason} ->
        Logger.error("Failed to connect to Sidekick agent: #{inspect(reason)}")
        timer = Process.send_after(self(), :reconnect, @reconnect_interval)
        {:noreply, %{state | reconnect_timer: timer}}
    end
  end

  @impl true
  def handle_info(:reconnect, state) do
    Logger.info("Attempting to reconnect to Sidekick agent...")
    {:noreply, state, {:continue, :connect}}
  end

  @impl true
  def handle_call(_request, _from, %{channel: nil} = state) do
    {:reply, {:error, "Not connected to Sidekick agent"}, state}
  end

  @impl true
  def handle_call(:list_simulators, _from, state) do
    result = call_grpc(state.channel, :list_simulators)
    {:reply, result, state}
  end

  @impl true
  def handle_call({:boot_simulator, identifier}, _from, state) do
    result = call_grpc(state.channel, :boot_simulator, %{identifier: identifier})
    {:reply, result, state}
  end

  @impl true
  def handle_call({:shutdown_simulator, identifier}, _from, state) do
    result = call_grpc(state.channel, :shutdown_simulator, %{identifier: identifier})
    {:reply, result, state}
  end

  @impl true
  def handle_call({:compile_project, opts}, _from, state) do
    result = call_grpc(state.channel, :compile_project, opts)
    {:reply, result, state}
  end

  @impl true
  def handle_call({:run_tests, opts}, _from, state) do
    result = call_grpc(state.channel, :run_tests, opts)
    {:reply, result, state}
  end

  @impl true
  def handle_call(:list_devices, _from, state) do
    result = call_grpc(state.channel, :list_devices)
    {:reply, result, state}
  end

  @impl true
  def handle_call(:xcode_version, _from, state) do
    result = call_grpc(state.channel, :xcode_version)
    {:reply, result, state}
  end

  @impl true
  def handle_call(:health_check, _from, state) do
    result = call_grpc(state.channel, :health_check)
    {:reply, result, state}
  end

  ## Private Functions

  defp establish_connection(server_url) do
    # TODO: Implement actual gRPC connection
    # For now, return a mock connection
    # This could fail in real implementation, so we keep the error handling
    if server_url do
      {:ok, %{url: server_url}}
    else
      {:error, "No server URL provided"}
    end
  end

  defp call_grpc(_channel, method, _params \\ %{}) do
    # Use Orchard to get actual platform information
    case method do
      :health_check -> :ok
      :xcode_version -> 
        # Orchard doesn't provide xcode_version, use system command instead
        case System.cmd("xcodebuild", ["-version"]) do
          {output, 0} -> 
            version = output |> String.split("\n") |> List.first() |> String.replace("Xcode ", "")
            {:ok, version}
          _ -> {:ok, "Unknown"}
        end
      :list_simulators -> 
        case Orchard.Simulator.list() do
          {:ok, simulators} -> 
            formatted_simulators = Enum.map(simulators, fn sim ->
              %{
                identifier: sim.udid,
                name: sim.name,
                display_name: sim.name,
                device: sim.device_type,
                os: sim.runtime,
                runtime: sim.runtime,
                state: sim.state,
                is_available: sim.state == "Booted"
              }
            end)
            {:ok, formatted_simulators}
          {:error, reason} -> 
            Logger.error("Failed to list simulators: #{inspect(reason)}")
            {:error, reason}
        end
      :list_devices -> 
        case Orchard.Device.list() do
          {:ok, devices} ->
            formatted_devices = Enum.map(devices, fn dev ->
              %{
                identifier: dev.udid,
                name: dev.name,
                display_name: dev.name,
                device: dev.device_type,
                state: dev.connection_type
              }
            end)
            {:ok, formatted_devices}
          {:error, reason} ->
            Logger.error("Failed to list devices: #{inspect(reason)}")
            {:error, reason}
        end
      _ -> {:error, "Not implemented"}
    end
  end
end