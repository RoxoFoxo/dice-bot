import Config

config :dice, :connection, Dice.Connection.Mock

config :dice, :steam_client, Dice.SteamClient.Mock

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dice, Dice.Repo,
  username: "postgres",
  password: "postgres",
  database: "dice_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dice, DiceWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
