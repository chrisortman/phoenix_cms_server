defmodule CmsServer.ConsentDocument do
  use CmsServer.Web, :model

  schema "consent_documents" do
    field :version, :string
    field :lastPublished, Ecto.DateTime
    has_many :sections, CmsServer.ConsentSection, foreign_key: :document_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:version, :lastPublished])
    |> validate_required([:version, :lastPublished])
  end
end
