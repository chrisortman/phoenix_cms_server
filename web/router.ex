defmodule CmsServer.Router do
  use CmsServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api"]
  end

  scope "/api", CmsServer do
    pipe_through :api
    resources "/consent-documents", ConsentDocumentController
    resources "/consent-sections", ConsentSectionController
  end

  scope "/", CmsServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/users", UsersController, :index
    post "/users", UsersController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", CmsServer do
  #   pipe_through :api
  # end
end
