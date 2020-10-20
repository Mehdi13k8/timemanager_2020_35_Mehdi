defmodule TimemanagerWeb.WorkingTimesController do
  use TimemanagerWeb, :controller

  alias Timemanager.Timer
  alias Timemanager.Timer.WorkingTimes

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Timer.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"working_times" => working_times_params}) do
    with {:ok, %WorkingTimes{} = working_times} <- Timer.create_working_times(working_times_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_times_path(conn, :show, working_times))
      |> render("show.json", working_times: working_times)
    end
  end

  def show(conn, %{"id" => id}) do
    working_times = Timer.get_working_times!(id)
    render(conn, "show.json", working_times: working_times)
  end

  def update(conn, %{"id" => id, "working_times" => working_times_params}) do
    working_times = Timer.get_working_times!(id)

    with {:ok, %WorkingTimes{} = working_times} <- Timer.update_working_times(working_times, working_times_params) do
      render(conn, "show.json", working_times: working_times)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_times = Timer.get_working_times!(id)

    with {:ok, %WorkingTimes{}} <- Timer.delete_working_times(working_times) do
      send_resp(conn, :no_content, "")
    end
  end
end
