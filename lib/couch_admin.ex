defmodule CmsServer.CouchAdmin do
  require Logger
  import Couchex

  def username_mutations(username) do

    hex_username = Base.encode16(username)

    database_name = "users-#{hex_username}"
    {hex_username, database_name}
  end

  @spec create_user(String.t) :: {:atom,String.t}
  def create_user(username) do


    doc_id = "org.couchdb.user:#{username}"

    user_doc = %{
      "_id" => doc_id,
      "name" => username,
      "password" => "welcome123",
      "roles" => [],
      "type" => "user"
    }

    {hex_username, database_name} = username_mutations(username)

    case save_doc(users_db, user_doc) do
      {:ok, new_doc} ->

        %{"_rev" => rev} = new_doc

        create_result = create_db(server_connection, database_name)
        Logger.debug "Create DB Result #{inspect(create_result)}"
        case create_result do
          {:ok, _ } ->
            {:success, "Created user #{username} with database users-#{hex_username}" }
          {:error, :unauthenticated} ->
            delete_doc(users_db, %{id: doc_id, rev: rev})
            {:error, "You do not have permission to create the user database"}
          {:error, reason} ->
            delete_doc(users_db, %{id: doc_id, rev: rev})
            {:error, "Could not create user database because #{reason}"}
        end

      {:error, :forbidden } ->
        { :error, "You do not have permission to create a user" }
      {:error, reason } ->
        { :error, "Failed to create user because #{reason}" }
    end
  end

  def list_users do

    all(users_db)
    |> Enum.filter(&user_document?/1)
    |> Enum.map(&read_username/1)

  end

  def admin_couch_server do
    server_connection('http://localhost:5984', [{:basic_auth, {"admin","welcome"}}])
  end

  def users_db do
    { :ok, users_db } = open_db(admin_couch_server, "_users")
    users_db
  end

  @doc ~S"""
    Determines if the given document is a user document

    ## Examples
    
        iex> CmsServer.CouchAdmin.user_document? %{"doc" => %{"_id" => "org.couchdb.user:chris"}}
        true

        iex> CmsServer.CouchAdmin.user_document? %{"doc" => %{"_id" => "poop"}}
        false

  """
  def user_document?(%{"doc" => %{"_id" => id }}) do
    String.starts_with?(id, "org.couchdb.user")
  end

  def read_username(%{"doc" => %{"name" => name}}) do
    name
  end

end
