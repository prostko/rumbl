defmodule RumblWeb.SessionController do
  use RumblWeb, :controller
  alias Rumbl.Repo
  alias Rumbl.Auth

  def new(conn, _) do
    render conn, :new
  end

  def create(conn, %{"session" => %{"username" => user, "password" => password}}) do
    case Auth.login_by_username_and_pass(conn, user, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome Back!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render(:new)
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout
    |> put_flash(:info, "Peace Out")
    |> redirect(to: "/")
  end
end
