defmodule Daemon.Application do
  @moduledoc """
  The Daemon OTP Application.

  This starts the supervision tree for Daemon, which includes
  Orchard for simulator management.
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Orchard is started as a dependency and manages simulators
      # We don't need to add anything here since Orchard starts its own supervision tree
    ]

    opts = [strategy: :one_for_one, name: Daemon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
