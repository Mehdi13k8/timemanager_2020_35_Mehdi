# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :timemanager,
  ecto_repos: [Timemanager.Repo]

# Configures the endpoint
config :timemanager, TimemanagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3atjpvbSvJC+z180SVV4NRWkQlYlphkNV/xQbul28r4BztAcfgAimN6s08wxqNrO",
  render_errors: [view: TimemanagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Timemanager.PubSub,
  live_view: [signing_salt: "alSnaLWg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  config :timemanager, Timemanager.Guardian,
       issuer: "timemanager",
       secret_key: "gyQyCnyGhyYMH/LIcnZRbHh6mjl4nXo1wNlzQpyEOloF8F1aH8u/2y+dSSZVbyeq"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
