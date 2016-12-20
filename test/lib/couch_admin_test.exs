defmodule CmsServer.CouchAdminTest do
  use ExUnit.Case, async: false

  alias CmsServer.CouchAdmin

  @moduletag :couchdb

  doctest CouchAdmin

  describe "create_user/1" do

    setup do
      server = CouchAdmin.admin_couch_server
      users_db = CouchAdmin.users_db
      case Couchex.lookup_doc_rev(users_db, 'org.couchdb.user:testuser4000') do
        {:ok, rev} -> Couchex.delete_doc(users_db, %{id: 'org.couchdb.user:testuser4000', rev: rev})
        {:error, :not_found} -> :ok
      end

      case Couchex.open_db(server, "users-746573747573657234303030") do
        {:ok, user_scope_db} -> Couchex.delete_db(user_scope_db)
        {:error, :not_found} -> :ok
      end

      :ok
    end

    test "User document and database should both exist" do
      users_db = CouchAdmin.users_db

      assert Couchex.doc_exists?(users_db, 'org.couchdb.user:testuser4000') == false
      assert Couchex.db_exists?(CouchAdmin.admin_couch_server, "users-746573747573657234303030") == false


      CouchAdmin.create_user("testuser4000")

      assert Couchex.doc_exists?(users_db, 'org.couchdb.user:testuser4000') == false
      assert Couchex.db_exists?(CouchAdmin.admin_couch_server, "users-746573747573657234303030") == false

    end
  end
end
