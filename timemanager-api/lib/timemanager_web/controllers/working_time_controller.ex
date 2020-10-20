defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller

  alias Timemanager.Timer
  alias Timemanager.Timer.WorkingTime

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, %{"userId" => userId}, _params) do
    startDate = _params["start"]
    endDate = _params["end"]
    workingtimes = Timer.get_working_time_by_userid!(userId, startDate, endDate)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"userId" => userId}, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Timer.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}, %{"userId" => userId}) do
    working_time = Timer.get_all_working_time_by_userId!(id, userId)
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
