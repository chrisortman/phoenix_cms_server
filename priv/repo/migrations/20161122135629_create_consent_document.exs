defmodule CmsServer.Repo.Migrations.CreateConsentDocument do
  use Ecto.Migration

  def change do
    create table(:consent_documents) do
      add :version, :string
      add :lastPublished, :datetime

      timestamps()
    end

  end
end
