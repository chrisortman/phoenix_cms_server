# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cms_server,
  ecto_repos: [CmsServer.Repo]

# Configures the endpoint
config :cms_server, CmsServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BjRkhoxc2lydtoPXS7rJFebevl7o2WNCxzfD8fomLYEbpbVjQwftsgcKSkws1w9+",
  render_errors: [view: CmsServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CmsServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phpenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
