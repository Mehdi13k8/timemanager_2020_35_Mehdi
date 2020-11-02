defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  alias Timemanager.Guardian

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", TimemanagerWeb do
    pipe_through :api
    # Users Login / Register
      post("/users/sign_in", UserController, :sign_in)
      post("/users", UserController, :create)
    end
    # resources "/users", UserController, only: [:create, :show]
  scope "/api/v1", TimemanagerWeb do
    pipe_through [:api, :jwt_authenticated]
    # Users Endpoints
    get("/users/my_user", UserController, :show_my_user)
    get("/users/all", UserController, :show_all)
    get("/users/:id", UserController, :show)
    get("/users", UserController, :index)
    put("/users/:id", UserController, :update)
    delete("/users/:id", UserController, :delete)

    # Clocs Endpoints
    get("/clocks/:userID", ClockController, :show)
    post("/clocks/:userID", ClockController, :create)

    # Working Times Endpoints
    post("/workingtimes/:userID", WorkingTimeController, :create)
    get("/workingtimes/:userID", WorkingTimeController, :index)
    get("/workingtimes/:userID/:workingtimeID", WorkingTimeController, :show) # Get 1 wrktime by Id
    # get("/workingtimes/:userID", WorkingTimeController, :index)
    # post("/workingtimes/:userID", WorkingTimeController, :create)
    put("/workingtimes/:id", WorkingTimeController, :update)
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
