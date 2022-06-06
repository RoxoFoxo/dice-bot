defmodule Dice.PlayersTest do
  use Dice.DataCase

  alias Dice.Players
  alias Dice.Players.User
  alias Dice.Repo

  @user %{
    "first_name" => "Roxo",
    "id" => 1_001_251_536,
    "is_bot" => false,
    "language_code" => "en",
    "last_name" => "💜",
    "username" => "RoxoFoxo"
  }

  @updated_user %{
    "first_name" => "Roxinho",
    "id" => 1_001_251_536,
    "is_bot" => false,
    "language_code" => "en",
    "last_name" => "💜",
    "username" => "xX_Roxo_Foxo_Xx"
  }

  @stored_user %User{
    name: "Roxo",
    id: 1_001_251_536,
    username: "RoxoFoxo"
  }

  describe "check_user/1" do
    test "add a user when its id isn't stored already" do
      assert [] = Repo.all(User)

      assert {:ok, user} = Players.check_user(@user)
      assert user.id == 1_001_251_536

      assert [user] = Repo.all(User)
      assert user.id == 1_001_251_536
    end

    test "doesn't update an user if their info is the same" do
      Repo.insert(@stored_user)

      assert :ok = Players.check_user(@user)
    end

    test "updates user if their info is different" do
      Repo.insert(@stored_user)

      assert {:ok, user} = Players.check_user(@updated_user)
      assert user.name == @updated_user["first_name"]
      assert user.username == @updated_user["username"]

      refute user.name == @user["first_name"]
      refute user.username == @user["username"]
    end
  end
end
