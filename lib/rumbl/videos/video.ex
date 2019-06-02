defmodule Rumbl.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :descriptions, :string
    field :title, :string
    field :url, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :descriptions])
    |> validate_required([:url, :title, :descriptions])
  end
end
