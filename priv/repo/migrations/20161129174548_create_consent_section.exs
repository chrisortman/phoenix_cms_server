defmodule CmsServer.Repo.Migrations.CreateConsentSection do
  use Ecto.Migration

  def change do
    create table(:consent_sections) do
      add :title, :string
      add :summary, :string
      add :researchKitType, :string
      add :learnMoreButtonTitle, :string

      timestamps()
    end

  end
end
