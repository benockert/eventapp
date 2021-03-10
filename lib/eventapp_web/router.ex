defmodule EventappWeb.Router do
  use EventappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EventappWeb.Plugs.FetchSession #checks for an active user session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EventappWeb do
    pipe_through :browser

    get "/", PageController, :index

    #adds the path for user profile pictures
    get "/users/picture/:id", UserController, :picture

    #adds the page /events to create new events
    resources "/events", PostController

    #adds the page /users to view user info
    resources "/users", UserController

    #adds the path for user sessions to support logging in
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", EventappWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  #TODO remove
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: EventappWeb.Telemetry
    end
  end
end
