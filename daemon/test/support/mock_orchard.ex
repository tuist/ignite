defmodule Daemon.Test.MockOrchard do
  @moduledoc """
  Mock implementation of Orchard functions for testing.
  """

  def mock_simulators do
    [
      %{
        udid: "00000000-0000-0000-0000-000000000001",
        name: "iPhone 15 Pro",
        device_type: "iPhone 15 Pro",
        runtime: "iOS 17.2",
        state: "Shutdown"
      },
      %{
        udid: "00000000-0000-0000-0000-000000000002",
        name: "iPhone 14",
        device_type: "iPhone 14",
        runtime: "iOS 17.2",
        state: "Booted"
      }
    ]
  end

  def mock_devices do
    [
      %{
        udid: "00000000-0000-0000-0000-000000000003",
        name: "Test iPhone",
        device_type: "iPhone 13 Pro",
        connection_type: "USB"
      }
    ]
  end
end