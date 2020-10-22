defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  scope "/api", TimemanagerWeb do
    pipe_through :api

    # Users Endpoints
    get("/users/:id", UserController, :show)
    get("/users", UserController, :index)
    post("/users", UserController, :create)
    put("/users/:id", UserController, :update)
    delete("/users/:id", UserController, :delete)

    # Clocs Endpoints
    get("/clocks/:userID", ClockController, :index)
    post("/clocks/:userID", ClockController, :create)

    # Working Times Endpoints
    post("/workingtimes/:userID", WorkingTimeController, :create)
    get("/workingtimes/:userID", WorkingTimeController, :index)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TimemanagerWeb.Telemetry
    end
  end
end
