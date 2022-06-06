defmodule Dice.Players do
  @moduledoc """
  This context is used to add and update user info.
  """
  import Ecto.Query, warn: false

  alias Dice.Players.User
  alias Dice.Repo

  @doc """
  %{
    "first_name" => "Roxo",
    "id" => 1001251536,
    "is_bot" => false,
    "language_code" => "en",
    "last_name" => "💜",
    "username" => "RoxoFoxo"
  }
  """
  def check_user(user) do
    stored_user = Repo.get_by(User, id: user["id"])
    attrs = %{username: user["username"], name: user["first_name"], id: user["id"]}

    with %User{} <- stored_user,
         true <- stored_user.name == user["first_name"],
         true <- stored_user.username == user["username"] do
      :ok
    else
      nil ->
        add_user(attrs)

      false ->
        update_user(stored_user, attrs)
    end
  end

  defp add_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  defp update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
