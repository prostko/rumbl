defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, socket}
  end

  # The handle_in method handles ALL incoming messages to a channel. 
  # It waits until it sees a message that matches the defined message here.
  def handle_in("new_annotation", params, socket) do

    # broadcast sends this payload to all of the channels open on this topic. 
    broadcast!(socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    })
    {:reply, :ok, socket}
  end
end
