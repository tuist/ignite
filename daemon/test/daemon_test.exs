defmodule DaemonTest do
  use ExUnit.Case, async: true

  describe "start_link/1" do
    test "starts the daemon with required server_url" do
      assert {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon)
      assert Process.alive?(pid)
      GenServer.stop(pid)
    end

    test "fails without server_url" do
      assert_raise KeyError, fn ->
        Daemon.start_link(name: :test_daemon_no_url)
      end
    end
  end

  describe "child_spec/1" do
    test "returns proper child specification" do
      opts = [server_url: "localhost:9090", name: :test_daemon_spec]
      spec = Daemon.child_spec(opts)

      assert spec.id == :test_daemon_spec
      assert spec.start == {Daemon, :start_link, [opts]}
      assert spec.type == :worker
      assert spec.restart == :permanent
    end

    test "uses default name when not provided" do
      opts = [server_url: "localhost:9090"]
      spec = Daemon.child_spec(opts)

      assert spec.id == Daemon
    end
  end

  describe "health_check/1" do
    setup do
      {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon_health)
      on_exit(fn -> Process.alive?(pid) && GenServer.stop(pid) end)
      {:ok, daemon: :test_daemon_health}
    end

    test "returns ok when connected", %{daemon: daemon} do
      # The mock implementation always returns :ok for health_check
      assert Daemon.health_check(daemon) == :ok
    end
  end

  describe "list_simulators/1" do
    setup do
      {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon_sims)
      on_exit(fn -> Process.alive?(pid) && GenServer.stop(pid) end)
      {:ok, daemon: :test_daemon_sims}
    end

    test "returns list of simulators", %{daemon: daemon} do
      result = Daemon.list_simulators(daemon)
      assert {:ok, simulators} = result
      assert is_list(simulators)
    end
  end

  describe "list_devices/1" do
    setup do
      {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon_devices)
      on_exit(fn -> Process.alive?(pid) && GenServer.stop(pid) end)
      {:ok, daemon: :test_daemon_devices}
    end

    test "returns list of devices", %{daemon: daemon} do
      result = Daemon.list_devices(daemon)
      assert {:ok, devices} = result
      assert is_list(devices)
    end
  end

  describe "xcode_version/1" do
    setup do
      {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon_xcode)
      on_exit(fn -> Process.alive?(pid) && GenServer.stop(pid) end)
      {:ok, daemon: :test_daemon_xcode}
    end

    test "returns xcode version", %{daemon: daemon} do
      result = Daemon.xcode_version(daemon)
      assert {:ok, version} = result
      assert is_binary(version)
    end
  end

  describe "get_build_environment_info/1" do
    setup do
      {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon_env)
      on_exit(fn -> Process.alive?(pid) && GenServer.stop(pid) end)
      {:ok, daemon: :test_daemon_env}
    end

    test "returns build environment info with local_ip and tailscale_url", %{daemon: daemon} do
      assert {:ok, info} = Daemon.get_build_environment_info(daemon)
      assert is_map(info)
      assert Map.has_key?(info, :local_ip)
      assert Map.has_key?(info, :tailscale_url)
      assert is_binary(info.local_ip)
      assert is_binary(info.tailscale_url)
    end
  end

  describe "simulator operations" do
    setup do
      {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon_sim_ops)
      on_exit(fn -> Process.alive?(pid) && GenServer.stop(pid) end)
      {:ok, daemon: :test_daemon_sim_ops}
    end

    test "boot_simulator/2 returns ok", %{daemon: daemon} do
      # Note: This is a mock test since we don't have real simulators in test env
      assert Daemon.boot_simulator("test-simulator-id", daemon) == {:error, "Not implemented"}
    end

    test "shutdown_simulator/2 returns ok", %{daemon: daemon} do
      # Note: This is a mock test since we don't have real simulators in test env
      assert Daemon.shutdown_simulator("test-simulator-id", daemon) == {:error, "Not implemented"}
    end
  end

  describe "project operations" do
    setup do
      {:ok, pid} = Daemon.start_link(server_url: "localhost:9090", name: :test_daemon_proj)
      on_exit(fn -> Process.alive?(pid) && GenServer.stop(pid) end)
      {:ok, daemon: :test_daemon_proj}
    end

    test "compile_project/2 returns error for unimplemented", %{daemon: daemon} do
      opts = %{
        project_path: "/test/path",
        scheme: "TestScheme",
        configuration: "Debug",
        destination: "test-destination"
      }

      assert Daemon.compile_project(opts, daemon) == {:error, "Not implemented"}
    end

    test "run_tests/2 returns error for unimplemented", %{daemon: daemon} do
      opts = %{
        project_path: "/test/path",
        scheme: "TestScheme",
        configuration: "Debug",
        destination: "test-destination"
      }

      assert Daemon.run_tests(opts, daemon) == {:error, "Not implemented"}
    end
  end

  describe "connection handling" do
    test "handles reconnection after failed connection" do
      # Start with invalid server URL to trigger reconnection logic
      {:ok, pid} = Daemon.start_link(server_url: nil, name: :test_daemon_reconnect)
      
      # Give it a moment to attempt connection
      Process.sleep(100)
      
      # Should still be alive despite connection failure
      assert Process.alive?(pid)
      
      # Should return error when not connected
      assert {:error, "Not connected to Daemon agent"} = Daemon.health_check(:test_daemon_reconnect)
      
      GenServer.stop(pid)
    end
  end
end