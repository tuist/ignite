defmodule Ignite.Schema do
  @moduledoc """
  Base schema module that uses UUIDv7 for primary keys.
  
  Usage:
      use Ignite.Schema
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      alias Ignite.Ecto.UUIDv7

      @primary_key {:id, UUIDv7, autogenerate: true}
      @foreign_key_type UUIDv7
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end