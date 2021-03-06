use Mix.Config

database_url = System.get_env("DATABASE_URL")

if(database_url) do
  config :regalocal, Regalocal.Repo,
    url: System.get_env("DATABASE_URL"),
    pool: Ecto.Adapters.SQL.Sandbox,
    types: PostgresTypes
else
  config :regalocal, Regalocal.Repo,
    database: "regalocal_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox,
    types: PostgresTypes
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :regalocal, RegalocalWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :cloudex,
  api_key: "my-api-key",
  secret: "my-secret",
  cloud_name: "my-cloud-name"
