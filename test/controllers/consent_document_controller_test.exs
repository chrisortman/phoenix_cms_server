defmodule CmsServer.ConsentDocumentControllerTest do
  use CmsServer.ConnCase

  alias CmsServer.ConsentDocument
  alias CmsServer.Repo

  @valid_attrs %{lastPublished: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, version: "some content"}
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
    conn = get conn, consent_document_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    consent_document = Repo.insert! %ConsentDocument{}
    conn = get conn, consent_document_path(conn, :show, consent_document)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{consent_document.id}"
    assert data["type"] == "consent_document"
    assert data["attributes"]["version"] == consent_document.version
    assert data["attributes"]["lastPublished"] == consent_document.lastPublished
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, consent_document_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, consent_document_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_document",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ConsentDocument, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, consent_document_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_document",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    consent_document = Repo.insert! %ConsentDocument{}
    conn = put conn, consent_document_path(conn, :update, consent_document), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_document",
        "id" => consent_document.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ConsentDocument, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    consent_document = Repo.insert! %ConsentDocument{}
    conn = put conn, consent_document_path(conn, :update, consent_document), %{
      "meta" => %{},
      "data" => %{
        "type" => "consent_document",
        "id" => consent_document.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    consent_document = Repo.insert! %ConsentDocument{}
    conn = delete conn, consent_document_path(conn, :delete, consent_document)
    assert response(conn, 204)
    refute Repo.get(ConsentDocument, consent_document.id)
  end

end
