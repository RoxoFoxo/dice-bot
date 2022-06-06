defmodule Dice.Players.User do
  @moduledoc """
  User schema, where it's stored the telegram's user id
  and first name and username if they have those available.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :name, :string
    field :telegram_id, :integer

    # many_to_many :games, Dice.GameSheet.Game, join_through: "users_games"
    has_many :users_games, Dice.GameSheet.UsersGames

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :telegram_id, :name])
    |> validate_required([:telegram_id])
    |> unique_constraint([:telegram_id])
  end
end
