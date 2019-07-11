defmodule Rumbl.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string

    has_many :videos, Rumbl.Videos.Video 
    has_many :annotaions, Rumbl.Annotations.Annotation

    timestamps()
  end

  @doc "changes"
  def changeset(user, attrs \\ :empty) do
    user
    |> cast(attrs, [:name, :username, :password, :password_hash])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, ~w(password)a, [])
    |> validate_length(:password, min: 1, max: 100)
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} -> put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ -> changeset
    end
  end
end
