defmodule CmsServer.PageController do
  use CmsServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
