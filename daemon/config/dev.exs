import Config

# Development configuration
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]