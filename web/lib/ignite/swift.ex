defmodule Ignite.Swift do
  @moduledoc """
  Interface for running Swift tooling within Ignite.
  """

  @doc """
  Runs the daemon-swift executable with the given arguments.
  
  In development, it runs through `swift run` in the daemon-swift directory.
  In production, it looks for `daemon-swift` in the same directory as the Ignite executable.
  """
  def run(args \\ []) when is_list(args) do
    case Mix.env() do
      :dev ->
        run_development(args)
      
      :test ->
        run_development(args)
      
      _ ->
        run_production(args)
    end
  end

  defp run_development(args) do
    # Change to daemon-swift directory
    original_dir = File.cwd!()
    daemon_dir = Path.join(original_dir, "daemon-swift")
    File.cd!(daemon_dir)
    
    cmd = "swift"
    swift_args = ["run", "daemon-swift", "--"] ++ args
    
    IO.puts("Running: #{cmd} #{Enum.join(swift_args, " ")}")
    
    result = case System.cmd(cmd, swift_args, into: IO.stream(:stdio, :line)) do
      {_, 0} -> :ok
      {_, exit_code} -> {:error, "Swift command failed with exit code: #{exit_code}"}
    end
    
    # Change back to original directory
    File.cd!(original_dir)
    result
  end

  defp run_production(args) do
    # Get the directory where the current executable is located
    executable_dir = 
      :code.priv_dir(:ignite)
      |> to_string()
      |> Path.dirname()
      |> Path.dirname()
    
    swift_executable = Path.join(executable_dir, "daemon-swift")
    
    if File.exists?(swift_executable) do
      IO.puts("Running: #{swift_executable} #{Enum.join(args, " ")}")
      
      case System.cmd(swift_executable, args, into: IO.stream(:stdio, :line)) do
        {_, 0} -> :ok
        {_, exit_code} -> {:error, "Swift executable failed with exit code: #{exit_code}"}
      end
    else
      {:error, "Swift executable not found at: #{swift_executable}"}
    end
  end
end