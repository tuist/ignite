defmodule IgniteWeb.AbsintheSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: IgniteWeb.GraphQL.Schema
  
  def connect(params, socket) do
    # TODO: Add authentication here
    # For now, accept all connections
    {:ok, assign(socket, :absinthe, %{
      context: %{
        current_user: params["user_id"],
        pubsub: socket.endpoint
      }
    })}
  end
  
  def id(_socket), do: nil
end