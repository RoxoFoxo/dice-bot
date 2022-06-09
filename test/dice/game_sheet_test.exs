defmodule Dice.GameSheetTest do
  use Dice.DataCase

  import Dice.Expectations

  alias Dice.GameSheet
  alias Dice.GameSheet.Game
  alias Dice.GameSheet.UsersGames
  alias Dice.Repo

  @game %Game{title: "Garry's Mod", id: 4000, suggester: 1_001_251_536}
  @game_info {:ok, %{prices: "R$ 25,99 | $9.99 | No discount", title: "Garry's Mod"}}
  @user %Dice.Players.User{id: 1_001_251_536}

  # I'll update this code at some point and have them not returning strings
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

  describe "delete_game/1" do
    test "deletes a game when gives its id" do
      Repo.insert(@game)

      assert [_game] = Repo.all(Game)

      GameSheet.delete_game(4000)

      assert [] = Repo.all(Game)
    end

    test "deletes a game when gives its title" do
      Repo.insert(@game)

      assert [_game] = Repo.all(Game)

      GameSheet.delete_game("Garry's Mod")

      assert [] = Repo.all(Game)
    end

    test "returns a not found message when game doesn't exist" do
      assert result = GameSheet.delete_game(4001)

      assert result ==
               "Sorry, I couldn't find that game in my database, maybe the id or title is incorrect?"
    end
  end

  describe "update_user_game_association/3" do
    test "creates and updates user association to a game" do
      Repo.insert(@game)
      Repo.insert(@user)

      assert [] = Repo.all(UsersGames)

      GameSheet.update_user_game_association(@user.id, @game.id, %{
        likes_it: false,
        owns_it: true
      })

      assert [assoc] = Repo.all(UsersGames)
      assert assoc.owns_it == true
      assert assoc.likes_it == false
      assert assoc.user_id == @user.id
      assert assoc.game_id == @game.id
    end

    test "returns an error message when the game doesn't exist" do
      Repo.insert(@user)

      assert message =
               GameSheet.update_user_game_association(@user.id, 4001, %{
                 likes_it: false,
                 owns_it: true
               })

      assert message ==
               "Sorry, I couldn't find that game in my database, maybe the id or title is incorrect?"

      assert [] = Repo.all(UsersGames)
    end
  end
end
