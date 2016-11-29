defmodule CmsServer.Repo.Migrations.AddKeyForConsentSections do
  use Ecto.Migration

  def change do
    alter table(:consent_sections) do
      add :document_id, references(:consent_documents)
    end
  end
end
