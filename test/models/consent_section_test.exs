defmodule CmsServer.ConsentSectionTest do
  use CmsServer.ModelCase

  alias CmsServer.ConsentSection

  @valid_attrs %{learnMoreButtonTitle: "some content", researchKitType: "some content", summary: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ConsentSection.changeset(%ConsentSection{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ConsentSection.changeset(%ConsentSection{}, @invalid_attrs)
    refute changeset.valid?
  end
end
