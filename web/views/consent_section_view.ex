defmodule CmsServer.ConsentSectionView do
  use CmsServer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :summary, :researchKitType, :learnMoreButtonTitle]

end
