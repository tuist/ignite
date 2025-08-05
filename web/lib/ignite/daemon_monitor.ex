defmodule Ignite.DaemonMonitor do
  use GenServer
  require Logger

  @check_interval 5_000 # Check every 5 seconds

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    # Start monitoring
    schedule_check()
    
    {:ok, %{connected: false}}
  end

  def handle_info(:check_connection, state) do
    connected = check_daemon_connection()
    
    # Only broadcast if status changed
    if connected != state.connected do
      Logger.info("Daemon connection status changed: #{connected}")
      Phoenix.PubSub.broadcast(Ignite.PubSub, "daemon_status", {:daemon_status, connected})
    end
    
    # Schedule next check
    schedule_check()
    
    {:noreply, %{state | connected: connected}}
  end

  defp schedule_check do
    Process.send_after(self(), :check_connection, @check_interval)
  end

  defp check_daemon_connection do
    case Daemon.health_check(Ignite.Daemon) do
      :ok -> true
      _ -> false
    end
  rescue
    _ -> false
  end
end