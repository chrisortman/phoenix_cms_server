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
alias CmsServer.ConsentSection
alias CmsServer.Repo


[ConsentSection, ConsentDocument] |> Enum.each(&Repo.delete_all(&1))

[
  %ConsentDocument{
    version: "V9",
    lastPublished: Ecto.DateTime.utc
  }

] |> Enum.each(&Repo.insert!(&1))

sections = [
  %{
    title: "General Health",
    researchKitType: "Overview",
  },
  %{
    title: "Purpose of Study",
    researchKitType: "Purpose",
  }
]

Repo.transaction fn ->
  doc = ConsentDocument |> Repo.get_by(version: "V9")
  Enum.each(sections, fn(section) ->
    Ecto.build_assoc(doc, :sections, Map.put(section, :document_id, doc.id))
    |> Repo.insert
  end)
end
