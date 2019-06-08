defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Videos
  alias Rumbl.Videos.Video
  alias Rumbl.Repo

  def index(conn, _params, _user) do
    videos = Videos.list_videos()
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> Ecto.build_assoc(:videos)
      |> Videos.change_video()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    changeset =
      user
      |> Ecto.build_assoc(:videos)
      |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    changeset = Videos.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, _user) do
    video = Videos.get_video!(id)

    case Videos.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    video = Videos.get_video!(id)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end
end
