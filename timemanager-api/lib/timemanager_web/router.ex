defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemanagerWeb do
    pipe_through :api

    get("/users/:id", UserController, :show)
    get("/users", UserController, :index)
    post("/users", UserController, :create)
    put("/users/:id", UserController, :update)
    delete("/users/:id", UserController, :delete)
    get("/workingtimes/:userId/:id", WorkingTimeController, :show)
    get("/workingtimes/:userId", WorkingTimeController, :index)
    post("/workingtimes/:userId", WorkingTimeController, :create)
    put("/workingtimes/:id", WorkingTimeController, :update)
    delete("/workingtimes/:id", WorkingTimeController, :delete)
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
