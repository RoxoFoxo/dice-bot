defmodule Dice.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :title, :string
      add :steam_id, :string
      add :suggester, :integer

      timestamps()
    end

    create unique_index(:games, [:title, :steam_id])
  end
end
