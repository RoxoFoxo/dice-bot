defmodule Dice.GameSheetTest do
  use Dice.DataCase

  import Dice.Expectations

  alias Dice.GameSheet
  alias Dice.GameSheet.Game
  alias Dice.Repo

  @game_info {:ok, %{prices: "R$ 25,99 | $9.99 | No discount", title: "Garry's Mod"}}
  @user %Dice.Players.User{id: 1_001_251_536}

  describe "add_steam_game/2" do
    test "add a game when given its id and calls its info back when used again" do
      expect_get_game_data(@game_info)
      expect_get_game_data(@game_info)
      Repo.insert(@user)

      assert [] = Repo.all(Game)

      GameSheet.add_steam_game("4000", 1_001_251_536)

      assert [game] = Repo.all(Game)
      assert game.id == 4000

      GameSheet.add_steam_game("4000", 1_000_000_800)

      assert [game] = Repo.all(Game)
      assert game.suggester == 1_001_251_536
    end

    test "doesn't add a game if the given id is incorrect" do
      expect_get_game_data({:error, :not_found})

      assert [] = Repo.all(Game)

      GameSheet.add_steam_game("4001", 1_001_251_536)

      assert [] = Repo.all(Game)
    end

    test "doesn't add a game if there is an unknown error" do
      expect_get_game_data({:error, :unknown_error})

      assert [] = Repo.all(Game)

      GameSheet.add_steam_game("4000", 1_001_251_536)

      assert [] = Repo.all(Game)
    end
  end
end
