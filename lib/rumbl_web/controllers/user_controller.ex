defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  plug :authenticate_user when action in [:index, :show]

  alias Rumbl.User
  alias Rumbl.Repo

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
