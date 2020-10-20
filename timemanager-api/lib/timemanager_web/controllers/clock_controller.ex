defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.Timer
  alias Timemanager.Timer.Clock

  action_fallback TimemanagerWeb.FallbackController

  #def index(conn, _params) do
  #  clocks = Timer.list_clocks()
  #  render(conn, "index.json", clocks: clocks)
  #end

  def create(conn, %{"userID" => userID}) do
    clock = %{"time" => NaiveDateTime.add(NaiveDateTime.utc_now(), 7200), "user" => userID, "status" => true }
    with {:ok, %Clock{} = clock} <- Timer.create_clock(clock) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"userID" => userID}) do
    clock = Timer.get_clock!(userID)
    render(conn, "show.json", clock: clock)
  end

  #def update(conn, %{"id" => id, "clock" => clock_params}) do
  #  clock = Timer.get_clock!(id)

  #  with {:ok, %Clock{} = clock} <- Timer.update_clock(clock, clock_params) do
  #    render(conn, "show.json", clock: clock)
  #  end
  #end

  #def delete(conn, %{"id" => id}) do
  #  clock = Timer.get_clock!(id)

  #  with {:ok, %Clock{}} <- Timer.delete_clock(clock) do
  #    send_resp(conn, :no_content, "")
  #  end
  #end
end
