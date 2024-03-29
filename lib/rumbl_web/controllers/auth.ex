defmodule Rumbl.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller

  alias Rumbl.User
  alias RumblWeb.Router.Helpers, as: Routes, as: Routes

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do 
      user = conn.assigns[:current_user] -> 
        put_current_user(conn, user)
      user = user_id && repo.get(Rumbl.User, user_id) -> 
        put_current_user(conn, user)
      true -> assign(conn, :current_user, nil)
    end 

    # user = user_id && repo.get(User, user_id)
    # assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn 
      |> assign(:current_user, user) 
      |> assign(:user_token, token)
  end

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    conn |> configure_session(drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "you must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
