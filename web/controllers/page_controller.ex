defmodule CmsServer.PageController do
  use CmsServer.Web, :controller

  def index(conn, _params) do
    db_props = %{protocol: "http", hostname: "localhost", database: "cms_backend", port: 5984}
    {:ok, %{"rows" => [%{"value" => count}]}} = 
      Couchdb.Connector.View.fetch_all(db_props, "howManySurveys", "how-many-surveys")
      |> Couchdb.Connector.AsMap.as_map

    render conn, "index.html", survey_count: count
  end
end
