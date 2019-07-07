defmodule RumblWeb.WatchController do
  use RumblWeb, :controller

  alias Rumbl.Videos.Video
  alias Rumbl.Repo

  def show(conn, %{"id" => id}) do
    render(conn, :show, video: Repo.get!(Video, id))
  end
end
