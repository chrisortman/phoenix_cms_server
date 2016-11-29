defmodule CmsServer.ConsentDocumentView do
  use CmsServer.Web, :view
  use JaSerializer.PhoenixView

  alias CmsServer.Repo

  attributes [:version, :lastPublished]
  has_many :sections, include: true, serializer: CmsServer.ConsentSectionView

  def sections(struct, conn) do
    case struct.sections do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:sections)
        |> Repo.all
      other -> other
    end
  end

end
