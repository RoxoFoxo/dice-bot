defmodule Dice.Repo.Migrations.CreateUsersGames do
  use Ecto.Migration

  def change do
    create table(:users_games) do
      add :owns_it, :boolean
      add :likes_it, :boolean
      add :game_id, references(:games)
      add :user_id, references(:users)
    end

    create index(:users_games, [:game_id, :user_id])
  end
end
