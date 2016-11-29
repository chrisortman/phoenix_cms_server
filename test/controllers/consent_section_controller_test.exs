defmodule CmsServer.ConsentSectionControllerTest do
  use CmsServer.ConnCase

  alias CmsServer.ConsentSection
  alias CmsServer.Repo

  @valid_attrs %{learnMoreButtonTitle: "some content", researchKitType: "some content", summary: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, consent_section_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    consent_section = Repo.insert! %ConsentSection{}
    conn = get conn, consent_section_path(conn, :show, consent_section)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{consent_section.id}"
    assert data["type"] == "consent-section"
    assert data["attributes"]["title"] == consent_section.title
    assert data["attributes"]["summary"] == consent_section.summary
    assert data["attributes"]["researchKitType"] == consent_section.researchKitType
    assert data["attributes"]["learnMoreButtonTitle"] == consent_section.learnMoreButtonTitle
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, consent_section_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, consent_section_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_section",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ConsentSection, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, consent_section_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_section",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    consent_section = Repo.insert! %ConsentSection{}
    conn = put conn, consent_section_path(conn, :update, consent_section), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_section",
        "id" => consent_section.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ConsentSection, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    consent_section = Repo.insert! %ConsentSection{}
    conn = put conn, consent_section_path(conn, :update, consent_section), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_section",
        "id" => consent_section.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    consent_section = Repo.insert! %ConsentSection{}
    conn = delete conn, consent_section_path(conn, :delete, consent_section)
    assert response(conn, 204)
    refute Repo.get(ConsentSection, consent_section.id)
  end

end
