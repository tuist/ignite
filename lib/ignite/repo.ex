defmodule Ignite.Repo do
  use Ecto.Repo,
    otp_app: :ignite,
    adapter: Ecto.Adapters.SQLite3
end