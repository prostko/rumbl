defmodule Rumbl.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :descriptions, :string
    field :title, :string
    field :url, :string

    belongs_to :user, Rumbl.User
    belongs_to :category, Rumbl.Categories.Category

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :descriptions, :category_id])
    |> validate_required([:url, :title, :descriptions])
    |> foreign_key_constraint(:category_id)
    |> assoc_constraint(:category)
  end
end
