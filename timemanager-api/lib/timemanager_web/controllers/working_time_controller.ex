defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller

  alias Timemanager.Timer
  alias Timemanager.Timer.WorkingTime

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, %{"userID" => userID}, _params) do
    startDate = _params["start"]
    endDate = _params["end"]
    workingtimes = Timer.get_working_time_by_user!(userID, startDate, endDate)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"userID" => userID}) do
    with {:ok, %WorkingTime{} = working_time} <- Timer.create_working_time(userID) do
      conn
      |> put_status(:created)
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"userID" => userID, "workingtimeID" => id}) do
    working_time = Timer.get_all_working_time_by_userId!(userID, id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Timer.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Timer.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Timer.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Timer.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end