# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :investing,
  ecto_repos: [Investing.Repo]

# Configures the endpoint
config :investing, InvestingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Iik6WiQn5gTaQdKNch0+CJkWIUHb45oYFbCSQiH+SU1mUJZIRsWfu11o4apEBjxF",
  render_errors: [view: InvestingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Investing.PubSub,
  live_view: [signing_salt: "yffrNPDM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :investing, Investing.Scheduler,
  debug_logging: true,
  jobs: [
    {"*/1 * * * *", {Investing.Heartbeat, :send, []}},
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
