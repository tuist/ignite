defmodule Ignite.GRPC.Server do
  use GRPC.Server, service: Daemon.Daemon.Service
  require Logger

  @doc """
  Health check endpoint
  """
  def health_check(_request, _stream) do
    Logger.debug("GRPC: health_check called")
    %Daemon.Empty{}
  end

  @doc """
  Set the current project path
  """
  def set_project_path(request, _stream) do
    Logger.debug("GRPC: set_project_path called with #{request.path}")
    
    # Create or update the project in the database
    project = Ignite.Project.from_path(request.path)
    
    case Ignite.Repo.insert(project, on_conflict: :replace_all, conflict_target: :path) do
      {:ok, _project} ->
        Logger.info("Project path set: #{request.path}")
        %Daemon.Empty{}
      
      {:error, changeset} ->
        Logger.error("Failed to save project: #{inspect(changeset.errors)}")
        raise GRPC.RPCError, status: :internal, message: "Failed to save project"
    end
  end

  @doc """
  Get Xcode version
  """
  def get_xcode_version(_request, _stream) do
    Logger.debug("GRPC: get_xcode_version called")
    
    case System.cmd("xcodebuild", ["-version"]) do
      {output, 0} ->
        lines = String.split(output, "\n", trim: true)
        version = parse_xcode_version(lines)
        build = parse_xcode_build(lines)
        
        %Daemon.XcodeVersionResponse{
          version: version || "Unknown",
          build: build || "Unknown"
        }
      
      {_output, _} ->
        %Daemon.XcodeVersionResponse{
          version: "Not installed",
          build: "N/A"
        }
    end
  end

  @doc """
  List all available destinations (simulators and devices)
  """
  def list_destinations(_request, _stream) do
    Logger.debug("GRPC: list_destinations called")
    
    # Get simulators
    simulators = get_simulator_destinations()
    
    # Get devices
    devices = get_device_destinations()
    
    # Combine all destinations
    destinations = simulators ++ devices
    
    %Daemon.ListDestinationsResponse{destinations: destinations}
  end

  @doc """
  List iOS simulators
  """
  def list_simulators(_request, _stream) do
    Logger.debug("GRPC: list_simulators called")
    
    case System.cmd("xcrun", ["simctl", "list", "devices", "available", "-j"]) do
      {output, 0} ->
        simulators = parse_simulators(output)
        %Daemon.ListSimulatorsResponse{simulators: simulators}
      
      {_output, _} ->
        %Daemon.ListSimulatorsResponse{simulators: []}
    end
  end

  @doc """
  Boot a simulator
  """
  def boot_simulator(request, _stream) do
    Logger.debug("GRPC: boot_simulator called with #{request.identifier}")
    
    case System.cmd("xcrun", ["simctl", "boot", request.identifier]) do
      {_output, 0} ->
        %Daemon.Empty{}
      
      {error, _} ->
        Logger.error("Failed to boot simulator: #{error}")
        raise GRPC.RPCError, status: :internal, message: "Failed to boot simulator: #{error}"
    end
  end

  @doc """
  Shutdown a simulator
  """
  def shutdown_simulator(request, _stream) do
    Logger.debug("GRPC: shutdown_simulator called with #{request.identifier}")
    
    case System.cmd("xcrun", ["simctl", "shutdown", request.identifier]) do
      {_output, 0} ->
        %Daemon.Empty{}
      
      {error, _} ->
        Logger.error("Failed to shutdown simulator: #{error}")
        raise GRPC.RPCError, status: :internal, message: "Failed to shutdown simulator: #{error}"
    end
  end

  @doc """
  List physical devices
  """
  def list_devices(_request, _stream) do
    Logger.debug("GRPC: list_devices called")
    
    case System.cmd("xcrun", ["devicectl", "list", "devices", "-j"]) do
      {output, 0} ->
        devices = parse_devices(output)
        %Daemon.ListDevicesResponse{devices: devices}
      
      {_output, _} ->
        # Fallback to empty list if devicectl is not available
        %Daemon.ListDevicesResponse{devices: []}
    end
  end

  @doc """
  Compile an Xcode project
  """
  def compile_project(request, _stream) do
    Logger.debug("GRPC: compile_project called")
    
    args = build_xcodebuild_args(request, "build")
    
    case System.cmd("xcodebuild", args, stderr_to_stdout: true) do
      {output, 0} ->
        %Daemon.CompileProjectResponse{
          success: true,
          output: output,
          error: "",
          exit_code: 0
        }
      
      {output, exit_code} ->
        %Daemon.CompileProjectResponse{
          success: false,
          output: output,
          error: "Build failed",
          exit_code: exit_code
        }
    end
  end

  @doc """
  Run tests for an Xcode project
  """
  def run_tests(request, _stream) do
    Logger.debug("GRPC: run_tests called")
    
    args = build_xcodebuild_args(request, "test")
    
    case System.cmd("xcodebuild", args, stderr_to_stdout: true) do
      {output, 0} ->
        {tests_run, tests_passed, tests_failed} = parse_test_results(output)
        
        %Daemon.RunTestsResponse{
          success: true,
          output: output,
          error: "",
          exit_code: 0,
          tests_run: tests_run,
          tests_passed: tests_passed,
          tests_failed: tests_failed
        }
      
      {output, exit_code} ->
        {tests_run, tests_passed, tests_failed} = parse_test_results(output)
        
        %Daemon.RunTestsResponse{
          success: false,
          output: output,
          error: "Tests failed",
          exit_code: exit_code,
          tests_run: tests_run,
          tests_passed: tests_passed,
          tests_failed: tests_failed
        }
    end
  end

  @doc """
  Get build environment info including local IP and Tailscale URL
  This asks sidekick for the information since it has access to the local system
  """
  def get_build_environment_info(_request, _stream) do
    Logger.debug("GRPC: get_build_environment_info called - asking sidekick")
    
    case Daemon.get_build_environment_info(Ignite.Daemon) do
      {:ok, info} ->
        %Daemon.BuildEnvironmentInfoResponse{
          local_ip: info.local_ip,
          tailscale_url: info.tailscale_url || ""
        }
      
      {:error, reason} ->
        Logger.error("Failed to get build environment info from sidekick: #{inspect(reason)}")
        raise GRPC.RPCError, status: :internal, message: "Failed to get build environment info"
    end
  end

  # Private helper functions

  defp get_simulator_destinations do
    case System.cmd("xcrun", ["simctl", "list", "devices", "available", "-j"]) do
      {output, 0} ->
        parse_destinations_from_simulators(output)
      
      {_output, _} ->
        []
    end
  end

  defp get_device_destinations do
    case System.cmd("xcrun", ["devicectl", "list", "devices", "-j"]) do
      {output, 0} ->
        parse_destinations_from_devices(output)
      
      {_output, _} ->
        []
    end
  end

  defp parse_destinations_from_simulators(json_output) do
    case Jason.decode(json_output) do
      {:ok, data} ->
        devices = Map.get(data, "devices", %{})
        
        Enum.flat_map(devices, fn {runtime, device_list} ->
          # Parse runtime to get platform and version
          {platform, version} = parse_runtime(runtime)
          
          Enum.map(device_list, fn device ->
            %Daemon.Destination{
              id: Map.get(device, "udid", ""),
              name: Map.get(device, "name", ""),
              platform: platform,
              os_version: version,
              device_type: parse_device_type(Map.get(device, "deviceTypeIdentifier", "")),
              type: :SIMULATOR,
              state: Map.get(device, "state", ""),
              is_available: Map.get(device, "isAvailable", true)
            }
          end)
        end)
      
      _ ->
        []
    end
  end

  defp parse_destinations_from_devices(json_output) do
    case Jason.decode(json_output) do
      {:ok, data} ->
        devices = Map.get(data, "result", %{}) |> Map.get("devices", [])
        
        Enum.map(devices, fn device ->
          device_props = Map.get(device, "deviceProperties", %{})
          hardware_props = Map.get(device, "hardwareProperties", %{})
          
          %Daemon.Destination{
            id: Map.get(device, "identifier", ""),
            name: Map.get(device_props, "name", ""),
            platform: "iOS", # Devices are typically iOS
            os_version: Map.get(device_props, "osVersion", ""),
            device_type: Map.get(hardware_props, "marketingName", Map.get(hardware_props, "productType", "")),
            type: :DEVICE,
            state: if(Map.get(device, "connectionProperties", %{}) |> Map.get("tunnelState", "") == "connected", do: "Connected", else: "Disconnected"),
            is_available: true
          }
        end)
      
      _ ->
        []
    end
  end

  defp parse_runtime(runtime) do
    cond do
      String.contains?(runtime, "iOS") ->
        version = runtime |> String.replace(~r/.*iOS-/, "") |> String.replace("-", ".")
        {"iOS", version}
      
      String.contains?(runtime, "watchOS") ->
        version = runtime |> String.replace(~r/.*watchOS-/, "") |> String.replace("-", ".")
        {"watchOS", version}
      
      String.contains?(runtime, "tvOS") ->
        version = runtime |> String.replace(~r/.*tvOS-/, "") |> String.replace("-", ".")
        {"tvOS", version}
      
      true ->
        {"Unknown", "Unknown"}
    end
  end

  defp parse_device_type(identifier) do
    identifier
    |> String.replace("com.apple.CoreSimulator.SimDeviceType.", "")
    |> String.replace("-", " ")
  end

  defp parse_xcode_version(lines) do
    version_line = Enum.find(lines, &String.starts_with?(&1, "Xcode"))
    if version_line do
      version_line
      |> String.replace("Xcode ", "")
      |> String.trim()
    end
  end

  defp parse_xcode_build(lines) do
    build_line = Enum.find(lines, &String.starts_with?(&1, "Build version"))
    if build_line do
      build_line
      |> String.replace("Build version ", "")
      |> String.trim()
    end
  end

  defp parse_simulators(json_output) do
    case Jason.decode(json_output) do
      {:ok, data} ->
        devices = Map.get(data, "devices", %{})
        
        Enum.flat_map(devices, fn {runtime, device_list} ->
          Enum.map(device_list, fn device ->
            %Daemon.Simulator{
              id: Map.get(device, "udid", ""),
              name: Map.get(device, "name", ""),
              device_type: Map.get(device, "deviceTypeIdentifier", ""),
              runtime: runtime,
              state: Map.get(device, "state", "")
            }
          end)
        end)
      
      _ ->
        []
    end
  end

  defp parse_devices(json_output) do
    case Jason.decode(json_output) do
      {:ok, data} ->
        devices = Map.get(data, "result", %{}) |> Map.get("devices", [])
        
        Enum.map(devices, fn device ->
          %Daemon.Device{
            id: Map.get(device, "identifier", ""),
            name: Map.get(device, "deviceProperties", %{}) |> Map.get("name", ""),
            model: Map.get(device, "hardwareProperties", %{}) |> Map.get("productType", ""),
            ios_version: Map.get(device, "deviceProperties", %{}) |> Map.get("osVersion", ""),
            connected: Map.get(device, "connectionProperties", %{}) |> Map.get("tunnelState", "") == "connected"
          }
        end)
      
      _ ->
        []
    end
  end

  defp build_xcodebuild_args(request, action) do
    args = [action]
    
    args = if request.project_path && request.project_path != "" do
      args ++ ["-project", request.project_path]
    else
      args
    end
    
    args = if request.scheme && request.scheme != "" do
      args ++ ["-scheme", request.scheme]
    else
      args
    end
    
    args = if request.configuration && request.configuration != "" do
      args ++ ["-configuration", request.configuration]
    else
      args
    end
    
    if request.destination && request.destination != "" do
      args ++ ["-destination", request.destination]
    else
      args
    end
  end

  defp parse_test_results(output) do
    lines = String.split(output, "\n")
    
    # Look for test summary line
    summary_line = Enum.find(lines, &String.contains?(&1, "Test Suite"))
    
    if summary_line && String.contains?(summary_line, "passed") do
      # Parse something like "Test Suite 'All tests' passed at 2024-01-15 10:30:45.123"
      # with "Executed 10 tests, with 0 failures"
      executed_line = Enum.find(lines, &String.contains?(&1, "Executed"))
      
      if executed_line do
        case Regex.run(~r/Executed (\d+) tests?, with (\d+) failures?/, executed_line) do
          [_, total, failures] ->
            total_int = String.to_integer(total)
            failures_int = String.to_integer(failures)
            {total_int, total_int - failures_int, failures_int}
          
          _ ->
            {0, 0, 0}
        end
      else
        {0, 0, 0}
      end
    else
      {0, 0, 0}
    end
  end
end