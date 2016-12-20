ExUnit.start

ExUnit.configure exclude: [:couchdb]
Ecto.Adapters.SQL.Sandbox.mode(CmsServer.Repo, :manual)

