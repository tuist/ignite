defmodule Sidekick.Application do
  @moduledoc """
  The Sidekick OTP Application.
  
  This starts the supervision tree for Sidekick, which includes
  Orchard for simulator management.
  """
  
  use Application
  
  @impl true
  def start(_type, _args) do
    children = [
      # Orchard is started as a dependency and manages simulators
      # We don't need to add anything here since Orchard starts its own supervision tree
    ]
    
    opts = [strategy: :one_for_one, name: Sidekick.Supervisor]
    Supervisor.start_link(children, opts)
  end
end