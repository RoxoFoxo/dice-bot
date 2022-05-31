defmodule Dice.GameSheet.Game do
  @moduledoc """
  This schema is where basic data from the game is stored together with
  who suggested it, so it's mentioned when the game is added again.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field(:title, :string)
    # save steam id as string and not integer pls
    field(:steam_id, :string)
    # I will remove this later, when I create the users table
    field(:suggester, :integer)

    # many_to_many :users, Dice.GameSheet.User, join_through: "games_users"

    timestamps()
  end

  def changeset(game, attrs) do
    game
    |> cast(attrs, [:title, :steam_id, :suggester])
    |> validate_required([:title, :steam_id, :suggester])
    |> unique_constraint([:title, :steam_id])
  end
end
