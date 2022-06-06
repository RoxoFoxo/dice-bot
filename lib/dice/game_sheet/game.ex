defmodule Dice.GameSheet.Game do
  @moduledoc """
  This schema is where basic data from the game is stored together with
  who suggested it, so it's mentioned when the game is added again.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: false}
  schema "games" do
    field :title, :string
    # I will remove this later, when I create the users table
    field :suggester, :integer

    # many_to_many :users, Dice.Players.User, join_through: "users_games"
    has_many :users_games, Dice.GameSheet.UsersGames

    timestamps()
  end

  def changeset(game, attrs) do
    game
    |> cast(attrs, [:id, :title, :suggester])
    |> validate_required([:id, :title, :suggester])
    |> unique_constraint([:id, :title])
  end
end
