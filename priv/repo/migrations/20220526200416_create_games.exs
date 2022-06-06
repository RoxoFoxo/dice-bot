defmodule Dice.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: {:id, :id, autogenerate: false}) do
      add :title, :string
      add :suggester, :integer

      timestamps()
    end

    create unique_index(:games, [:title])
  end
end
