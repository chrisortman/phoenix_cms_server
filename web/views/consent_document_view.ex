defmodule CmsServer.ConsentDocumentView do
  use CmsServer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:version, :lastPublished, :inserted_at, :updated_at]
  

end
