defmodule Daemon.ApplicationTest do
  use ExUnit.Case, async: true

  describe "start/2" do
    test "starts the supervisor with correct configuration" do
      # Stop the application if it's already running (from the test environment)
      Application.stop(:daemon)

      # Start the application
      assert {:ok, pid} = Daemon.Application.start(:normal, [])
      assert Process.alive?(pid)

      # Check the supervisor is registered with the correct name
      assert Process.whereis(Daemon.Supervisor) == pid

      # Check supervisor has correct strategy
      {:ok, {supervisor_spec, _children}} = :supervisor.get_childspec(pid, :supervisor)
      assert supervisor_spec.strategy == :one_for_one

      # Clean up
      Process.exit(pid, :normal)
    end

    test "returns empty children list" do
      # The application should start with no children since Orchard manages its own supervision tree
      Application.stop(:daemon)
      {:ok, pid} = Daemon.Application.start(:normal, [])

      children = Supervisor.which_children(pid)
      assert children == []

      Process.exit(pid, :normal)
    end
  end
end