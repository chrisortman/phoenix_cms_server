defmodule CmsServer.UsersController do
  use CmsServer.Web, :controller
  alias CmsServer.CouchAdmin

  def index(conn, _params) do

    users = CouchAdmin.list_users

    render conn, "index.html", user_count: Enum.count(users), names: users
  end

  def create(conn, %{"create_user" => %{"username" => username}}) do

    {status, message} = CouchAdmin.create_user(username)

    conn
    |> put_flash(status, message)
    |> redirect(to: "/users")

  end



end
