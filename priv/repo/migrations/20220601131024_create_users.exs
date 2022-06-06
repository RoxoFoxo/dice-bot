defmodule Dice.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: {:id, :id, autogenerate: false}) do
      add :username, :string
      add :name, :string

      timestamps()
    end
  end
end
