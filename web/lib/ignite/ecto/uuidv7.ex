defmodule Ignite.Ecto.UUIDv7 do
  @moduledoc """
  An Ecto type for UUIDv7 (time-ordered UUIDs).
  
  UUIDv7 includes a timestamp which makes them naturally sortable by creation time.
  """

  use Ecto.Type

  @type t :: <<_::288>>

  @impl true
  def type, do: :uuid

  @impl true
  def cast(value) do
    Ecto.UUID.cast(value)
  end

  @impl true
  def load(value) do
    Ecto.UUID.load(value)
  end

  @impl true
  def dump(value) do
    Ecto.UUID.dump(value)
  end

  @impl true
  def embed_as(_), do: :self

  @impl true
  def equal?(a, b), do: a == b

  @doc """
  Callback invoked by autogenerate.
  """
  @impl true
  def autogenerate, do: generate()

  @doc """
  Generates a new UUIDv7.
  """
  def generate do
    # Get current timestamp in milliseconds
    timestamp = System.system_time(:millisecond)
    
    # UUIDv7 format:
    # - 48 bits: timestamp (milliseconds since Unix epoch)
    # - 4 bits: version (0111 = 7)
    # - 12 bits: random
    # - 2 bits: variant (10)
    # - 62 bits: random
    
    <<timestamp_high::32, timestamp_low::16>> = <<timestamp::48>>
    
    # Generate random bits
    <<rand_a::12, rand_b::62, _::2>> = :crypto.strong_rand_bytes(10)
    
    # Build the UUID
    <<timestamp_high::32, timestamp_low::16, 7::4, rand_a::12, 2::2, rand_b::62>>
    |> Base.encode16(case: :lower)
    |> format_uuid()
  end

  @doc """
  Generates a new UUIDv7 in binary format.
  """
  def bingenerate do
    timestamp = System.system_time(:millisecond)
    <<timestamp_high::32, timestamp_low::16>> = <<timestamp::48>>
    <<rand_a::12, rand_b::62, _::2>> = :crypto.strong_rand_bytes(10)
    
    <<timestamp_high::32, timestamp_low::16, 7::4, rand_a::12, 2::2, rand_b::62>>
  end

  defp format_uuid(hex) do
    <<a::binary-8, b::binary-4, c::binary-4, d::binary-4, e::binary-12>> = hex
    "#{a}-#{b}-#{c}-#{d}-#{e}"
  end

  @doc """
  Extracts the timestamp from a UUIDv7.
  """
  def extract_timestamp(uuid) when is_binary(uuid) do
    with {:ok, binary} <- Ecto.UUID.dump(uuid) do
      <<timestamp::48, _::80>> = binary
      {:ok, DateTime.from_unix!(timestamp, :millisecond)}
    end
  end
end