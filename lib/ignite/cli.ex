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
    Mix.ensure_application!(:ignite)
    Process.sleep(:infinity)
  end
end