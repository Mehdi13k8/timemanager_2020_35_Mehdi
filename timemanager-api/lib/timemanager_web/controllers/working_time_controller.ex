defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller

  alias Timemanager.Timer
  alias Timemanager.Timer.WorkingTime

  action_fallback TimemanagerWeb.FallbackController


  def index(conn, %{"userID" => userID, "start" => start_date, "end" => end_date}) do
    start_date = NaiveDateTime.from_iso8601!(start_date)
    end_date = NaiveDateTime.from_iso8601!(end_date)

    workingtimes = Timer.get_working_times!(userID, start_date, end_date)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"userID" => userID, "start" => start_date, "end" => end_date}) do
    working_time = %{
      "start" => NaiveDateTime.from_iso8601!(start_date),
      "end" => NaiveDateTime.from_iso8601!(end_date),
      "user" => userID
    }
    with {:ok, %WorkingTime{} = working_time} <- Timer.create_working_time(working_time) do
      conn
      |> put_status(:created)
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"userID" => user_id, "workingtimeID" => id}) do
    working_time = Timer.get_working_time!(id)
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
