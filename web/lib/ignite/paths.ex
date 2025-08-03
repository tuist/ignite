defmodule Ignite.Paths do
  @moduledoc """
  Handles XDG-compliant paths for Ignite application data.
  """

  @doc """
  Get the data directory for Ignite following XDG Base Directory specification.
  Falls back to ~/.local/share/ignite if XDG_DATA_HOME is not set.
  """
  def data_dir do
    base_dir = System.get_env("XDG_DATA_HOME") || Path.join(System.user_home!(), ".local/share")
    Path.join(base_dir, "ignite")
  end

  @doc """
  Get the database path for Ignite.
  """
  def database_path do
    Path.join(data_dir(), "ignite.db")
  end

  @doc """
  Ensure the data directory exists.
  """
  def ensure_data_dir! do
    dir = data_dir()
    File.mkdir_p!(dir)
    dir
  end
end