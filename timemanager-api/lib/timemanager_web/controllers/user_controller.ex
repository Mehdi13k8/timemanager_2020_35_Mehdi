defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Account
  alias Timemanager.Account.User
  alias Timemanager.Guardian

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  def show_all(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

   # Create account
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
          conn 
            |> render("jwt.json", jwt: token)
      # |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      # |> render("show.json", user: user)
    end
  end

  def show_my_user(conn, _params) do
     user = Guardian.Plug.current_resource(conn)
     conn |> render("user.json", user: user)
  end

  # Login account
  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Account.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Account.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.user_path(conn, :show, user))
  #     |> render("show.json", user: user)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
