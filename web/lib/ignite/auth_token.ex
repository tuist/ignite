defmodule Ignite.AuthToken do
  @moduledoc """
  Manages the authentication token for GRPC communication between
  the server and Daemon.
  """
  
  use Agent
  require Logger

  def start_link(_opts) do
    Agent.start_link(fn -> generate_token() end, name: __MODULE__)
  end

  @doc """
  Get the current authentication token
  """
  def get_token do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Generate a new random token
  """
  def generate_token do
    token = :crypto.strong_rand_bytes(32) |> Base.encode64()
    Logger.info("Generated new GRPC authentication token")
    token
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent
    }
  end
end