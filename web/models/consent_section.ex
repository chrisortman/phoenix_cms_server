defmodule CmsServer.ConsentSection do
  use CmsServer.Web, :model

  schema "consent_sections" do
    field :title, :string
    field :summary, :string
    field :researchKitType, :string
    field :learnMoreButtonTitle, :string
    belongs_to :document, CmsServer.ConsentDocument, foreign_key: :document_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :summary, :researchKitType, :learnMoreButtonTitle])
    |> validate_required([:title, :summary, :researchKitType, :learnMoreButtonTitle])
  end
end
