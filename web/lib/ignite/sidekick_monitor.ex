defmodule Ignite.SidekickMonitor do
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
    connected = check_sidekick_connection()
    
    # Only broadcast if status changed
    if connected != state.connected do
      Logger.info("Sidekick connection status changed: #{connected}")
      Phoenix.PubSub.broadcast(Ignite.PubSub, "sidekick_status", {:sidekick_status, connected})
    end
    
    # Schedule next check
    schedule_check()
    
    {:noreply, %{state | connected: connected}}
  end

  defp schedule_check do
    Process.send_after(self(), :check_connection, @check_interval)
  end

  defp check_sidekick_connection do
    case Sidekick.health_check(Ignite.Sidekick) do
      :ok -> true
      _ -> false
    end
  rescue
    _ -> false
  end
end