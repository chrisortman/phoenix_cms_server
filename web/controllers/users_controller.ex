defmodule CmsServer.UsersController do
  use CmsServer.Web, :controller
  require Logger
  import Couchex

  def index(conn, _params) do

    user_docs = all(users_db) 
                |> Enum.filter(&user_document?/1)
                |> Enum.map(&read_username/1)

    render conn, "index.html", user_count: Enum.count(user_docs), names: user_docs
  end

  def create(conn, %{"create_user" => %{"username" => username}}) do

    {status, message} = create_user(username)

    conn
    |> put_flash(status, message)
    |> redirect(to: "/users")

  end

  defp admin_couch_server do
    server_connection('http://localhost:5984', [{:basic_auth, {"admin","welcome"}}])
  end

  defp users_db do
    { :ok, users_db } = open_db(admin_couch_server, "_users")
    users_db
  end

  defp user_document?(%{"doc" => %{"_id" => id }}) do
    String.starts_with?(id, "org.couchdb.user")
  end

  defp read_username(%{"doc" => %{"name" => name}}) do
    name
  end

  defp create_user(username) do

    doc_id = "org.couchdb.user:#{username}"

    user_doc = %{
      "_id" => doc_id,
      "name" => username,
      "password" => "welcome123",
      "roles" => [],
      "type" => "user"
    }

    hex_username = Base.encode16(username)
    database_name = "users-#{hex_username}"

    case save_doc(users_db, user_doc) do
      {:ok, new_doc} ->

        create_result = create_db(server_connection, database_name)
        Logger.debug "Create DB Result #{inspect(create_result)}"
        case create_result do
          {:ok, _ } ->
            {:success, "Created user #{username} with database users-#{hex_username}" }
          {:error, :unauthenticated} ->
            delete_doc(users_db, new_doc)
            {:error, "You do not have permission to create the user database"}
          {:error, reason} ->
            delete_doc(users_db, new_doc)
            {:error, "Could not create user database because #{reason}"}
        end

      {:error, :forbidden } ->
        { :error, "You do not have permission to create a user" }
      {:error, reason } ->
        { :error, "Failed to create user because #{reason}" }
    end
  end
end
