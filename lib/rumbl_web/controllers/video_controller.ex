defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Videos
  alias Rumbl.Videos.Video
  alias Rumbl.Categories
  alias Rumbl.Categories.Category
  alias Rumbl.Repo

  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, _params, user) do
    videos = Repo.all(user_videos(user))
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

  def show(conn, %{"id" => id}, user) do
    video = Repo.get(user_videos(user), id)

    case video do
      nil ->
        conn
        |> put_flash(:error, "Video not found")
        |> redirect(to: Routes.video_path(conn, :index))

      video ->
        cat = Categories.get_category!(video.category_id)
        render(conn, "show.html", video: video, cat: cat)
    end
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

  def delete(conn, %{"id" => id}, user) do
    case Repo.get(user_videos(user), id) do
      nil ->
        conn
        |> put_flash(:error, "Video not found")
        |> redirect(to: Routes.video_path(conn, :index))

      video ->
        Videos.delete_video(video)
        conn
        |> put_flash(:info, "Video deleted successfully.")
        |> redirect(to: Routes.video_path(conn, :index))
    end
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def user_videos(user) do
    Ecto.assoc(user, :videos)
  end

  def load_categories(conn, _) do
    categories = Categories.list_categories()
    assign(conn, :categories, categories)
  end
end
