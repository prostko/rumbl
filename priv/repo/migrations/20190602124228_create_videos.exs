defmodule Rumbl.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :url, :string
      add :title, :string
      add :descriptions, :text
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:videos, [:user_id])
  end
end
