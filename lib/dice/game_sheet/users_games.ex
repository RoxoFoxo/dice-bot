defmodule Dice.GameSheet.UsersGames do
  @moduledoc """
  This schema is the association between Players.User and GameSheet.Game.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_games" do
    field :owns_it, :boolean
    field :likes_it, :boolean
    belongs_to :game, Dice.GameSheet.Game
    belongs_to :user, Dice.Players.User
  end

  def changeset(users_games, attrs) do
    users_games
    |> cast(attrs, [:owns_it, :likes_it, :game_id, :user_id])
    |> validate_required([:game_id, :user_id])
    |> foreign_key_constraint(:game_id)
  end
end
