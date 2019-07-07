defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase

  alias Rumbl.Videos

  @create_attrs %{descriptions: "some descriptions", title: "some title", url: "some url"}
  @update_attrs %{descriptions: "some updated descriptions", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{descriptions: nil, title: nil, url: nil}

  def fixture(:video) do
    {:ok, video} = Videos.create_video(@create_attrs)
    video
  end
end
