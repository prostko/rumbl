defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel
  import Ecto.Query
  alias Rumbl.Repo
  alias Rumbl.Videos.Video
  alias Rumbl.User
  alias Rumbl.Annotations.Annotation
  alias RumblWeb.AnnotationView

  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["lastSeenId"] || 0
    video = Repo.get!(Video, video_id)

    annotations = Repo.all(
      from a in Ecto.assoc(video, :annotations),
       where: a.id > ^last_seen_id,
       order_by: [asc:  a.at, asc: a.id],
       limit: 200,
       preload: [:user]
    )
    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}

    {:ok, resp, assign(socket, :video_id, String.to_integer(video_id)) } 
  end

  def handle_in(event, params, socket) do
    handle_in(event, params, user(socket), socket)
  end

  # The handle_in method handles ALL incoming messages to a channel. 
  # It waits until it sees a message that matches the defined message here.
  def handle_in("new_annotation", params, user, socket) do
    changeset = user
                 |> Ecto.build_assoc(:annotations, video_id: socket.assigns.video_id) 
                 |> Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:error, changeset} -> 
        {:reply, {:error, %{ errors: changeset }}, socket}  

      {:ok, annotation} -> 
        # broadcast sends this payload to all of the channels open on this topic. 
        broadcast!(socket, "new_annotation", %{
          user: RumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })

        {:reply, :ok, socket}
    end
  end

  def user(socket) do
    Repo.get(User, socket.assigns.user_id)
  end
end
