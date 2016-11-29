defmodule CmsServer.ConsentSectionController do
  use CmsServer.Web, :controller

  alias CmsServer.ConsentSection
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    consent_sections = Repo.all(ConsentSection)
    render(conn, "index.json-api", data: consent_sections)
  end

  def create(conn, %{"data" => data = %{"type" => "consent_section", "attributes" => _consent_section_params}}) do
    changeset = ConsentSection.changeset(%ConsentSection{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, consent_section} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", consent_section_path(conn, :show, consent_section))
        |> render("show.json-api", data: consent_section)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    consent_section = Repo.get!(ConsentSection, id)
    render(conn, "show.json-api", data: consent_section)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "consent_section", "attributes" => _consent_section_params}}) do
    consent_section = Repo.get!(ConsentSection, id)
    changeset = ConsentSection.changeset(consent_section, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, consent_section} ->
        render(conn, "show.json-api", data: consent_section)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    consent_section = Repo.get!(ConsentSection, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(consent_section)

    send_resp(conn, :no_content, "")
  end

end
