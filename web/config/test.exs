import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ignite, IgniteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "96jSoeCavAtQIAwhCh90ZzhEitvueo5IL0176iIRJhXFa61pNu0BqOB2pzwuOu7L",
  server: false

# In test we don't send emails
config :ignite, Ignite.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
