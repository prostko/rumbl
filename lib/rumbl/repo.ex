defmodule Rumbl.Repo do
  use Ecto.Repo,
    otp_app: :rumbl,
    adapter: Ecto.Adapters.Postgres
end

#defmodule Rumbl.Repo do
#  @moduledoc """
#    In memory of repository
#  """
#
#  def all(Rumbl.User) do
#    [%Rumbl.User{id: "1", name: "John", username: "johnjohn", password: "asdf"},
#     %Rumbl.User{id: "2", name: "Jill", username: "jilljill", password: "asdf"},
#     %Rumbl.User{id: "3", name: "Jack", username: "jackjack", password: "asdf"}]
#  end
#  def all(_module), do: []
#
#  def get(module, id) do
#    Enum.find all(module), fn map -> map.id == id end
#  end
#
#  def get_by(module, params) do
#    Enum.find all(module), fn map ->
#      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
#    end
#  end
#end
