defmodule Dice.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :name, :string
      add :telegram_id, :integer

      timestamps()
    end

    create unique_index(:users, [:telegram_id])
  end
end
