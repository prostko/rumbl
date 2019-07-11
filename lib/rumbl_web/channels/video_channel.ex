defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel
  alias Rumbl.Repo
  alias Rumbl.User
  alias Rumbl.Annotations.Annotation

  def join("videos:" <> video_id, _params, socket) do
    {:ok, assign(socket, :video_id, String.to_integer(video_id)) } 
  end

  # The handle_in method handles ALL incoming messages to a channel. 
  # It waits until it sees a message that matches the defined message here.
  def handle_in("new_annotation", params, socket) do
    changeset = Repo.get(User, socket.assigns.user_id)
    |> Ecto.build_assoc(:annotations, video_id: socket.assigns.video_id) 
    |> Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} -> 
        # broadcast sends this payload to all of the channels open on this topic. 
        broadcast!(socket, "new_annotation", %{
          user: %{username: "anon"},
          body: params["body"],
          at: params["at"]
        })
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{ errors: changeset }}, socket}  
    end
  end
end
