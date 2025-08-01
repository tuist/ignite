defmodule Ignite.CLI do
  @moduledoc """
  Command-line interface for Ignite
  """

  def main(args \\ []) do
    case args do
      ["--version"] -> show_version()
      ["version"] -> show_version()
      _ -> start_server()
    end
  end

  defp show_version do
    version = Application.spec(:ignite, :vsn) |> to_string()
    IO.puts("ignite #{version}")
  end

  defp start_server do
    Application.put_env(:phoenix, :serve_endpoints, true, persistent: true)
    Application.put_env(:ignite, :launch_browser, true)
    
    # Set up signal handlers to ensure clean shutdown
    :ok = :logger.add_handler(:signal_handler, :logger_std_h, %{})
    
    # Trap exit signals to ensure browser process is cleaned up
    Process.flag(:trap_exit, true)
    
    # Start the application
    {:ok, _} = Application.ensure_all_started(:ignite)
    
    # Keep the process alive and handle shutdown signals
    receive do
      {:EXIT, _from, reason} ->
        IO.puts("\nShutting down...")
        Application.stop(:ignite)
        System.halt(0)
        
      :shutdown ->
        IO.puts("\nShutting down...")
        Application.stop(:ignite)
        System.halt(0)
    end
  end
end