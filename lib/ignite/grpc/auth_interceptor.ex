defmodule Ignite.GRPC.AuthInterceptor do
  @behaviour GRPC.Server.Interceptor

  require Logger

  @impl true
  def init(opts) do
    opts
  end

  @impl true
  def call(req, stream, next, _opts) do
    with {:ok, token} <- get_auth_token(stream),
         :ok <- verify_token(token) do
      next.(req, stream)
    else
      {:error, :missing_token} ->
        raise GRPC.RPCError, status: :unauthenticated, message: "Missing authentication token"
      
      {:error, :invalid_token} ->
        raise GRPC.RPCError, status: :unauthenticated, message: "Invalid authentication token"
    end
  end

  defp get_auth_token(stream) do
    case GRPC.Stream.get_headers(stream) do
      headers when is_map(headers) ->
        case Map.get(headers, "authorization") do
          "Bearer " <> token -> {:ok, token}
          _ -> {:error, :missing_token}
        end
      
      _ ->
        {:error, :missing_token}
    end
  end

  defp verify_token(token) do
    expected_token = Ignite.AuthToken.get_token()
    
    if token == expected_token do
      :ok
    else
      Logger.warning("Invalid GRPC authentication token received")
      {:error, :invalid_token}
    end
  end
end