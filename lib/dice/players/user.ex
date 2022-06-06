defmodule Dice.Players.User do
  @moduledoc """
  User schema, where it's stored the telegram's user id
  and first name and username if they have those available.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: false}
  schema "users" do
    field :username, :string
    field :name, :string

    # many_to_many :games, Dice.GameSheet.Game, join_through: "users_games"
    has_many :users_games, Dice.GameSheet.UsersGames

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :id, :name])
    |> validate_required([:id])
    |> unique_constraint([:id])
  end
end
