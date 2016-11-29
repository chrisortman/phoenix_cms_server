defmodule CmsServer.ConsentDocumentTest do
  use CmsServer.ModelCase

  alias CmsServer.ConsentDocument

  @valid_attrs %{lastPublished: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, version: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ConsentDocument.changeset(%ConsentDocument{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ConsentDocument.changeset(%ConsentDocument{}, @invalid_attrs)
    refute changeset.valid?
  end
end
