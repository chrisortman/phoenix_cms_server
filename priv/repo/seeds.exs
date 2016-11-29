# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CmsServer.Repo.insert!(%CmsServer.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CmsServer.ConsentDocument
alias CmsServer.Repo

[
  %ConsentDocument{
    version: "V9",
    lastPublished: Ecto.DateTime.utc
  }

] |> Enum.each(&Repo.insert!(&1))
