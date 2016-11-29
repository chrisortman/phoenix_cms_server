defmodule CmsServer.ConsentDocumentController do
  use CmsServer.Web, :controller

  alias CmsServer.ConsentDocument
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    consent_documents = Repo.all from c in ConsentDocument,
                                 preload: [:sections]

    render(conn, data: consent_documents)
  end

  def create(conn, %{"data" => data = %{"type" => "consent_document", "attributes" => _consent_document_params}}) do
    changeset = ConsentDocument.changeset(%ConsentDocument{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, consent_document} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", consent_document_path(conn, :show, consent_document))
        |> render("show.json-api", data: consent_document)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    consent_document = Repo.get!(ConsentDocument, id)
    render(conn, "show.json-api", data: consent_document)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "consent_document", "attributes" => _consent_document_params}}) do
    consent_document = Repo.get!(ConsentDocument, id)
    changeset = ConsentDocument.changeset(consent_document, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, consent_document} ->
        render(conn, "show.json-api", data: consent_document)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    consent_document = Repo.get!(ConsentDocument, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(consent_document)

    send_resp(conn, :no_content, "")
  end

end
