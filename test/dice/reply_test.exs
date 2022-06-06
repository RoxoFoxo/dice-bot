defmodule Dice.ReplyTest do
  use Dice.DataCase

  import Dice.Expectations

  alias Dice.GameSheet.Game
  alias Dice.Reply
  alias Dice.Repo

  @paw_file_id "CAACAgEAAxkBAANeYBCKLIhaKQwOobteRP3a5quwUsIAAh8AAxeZ2Q7IeDvomNaN1B4E"
  @cutie_file_id "CAACAgEAAxkBAANyYBDao0rvEg4hd3aH-JM7qRAVXQQAAgUAA5T5DDXKWqGUl7FB1R4E"
  @game_insert %Game{title: "Garry's Mod", id: 4000, suggester: 1_001_251_536}
  @steam_game_message """
  Garry's Mod | Suggested by: <a href="tg://user?id=1001251536">this person</a>
  R$ 25,99 | $9.99 | No discount
  https://store.steampowered.com/app/4000
  """

  def create_message(text, :text) do
    %{
      "message" => %{
        "chat" => %{"id" => 1_001_251_536},
        "from" => %{"id" => 1_001_251_536},
        "text" => text
      }
    }
  end

  def create_message(emoji, :sticker_emoji) do
    %{"message" => %{"chat" => %{"id" => 1_001_251_536}, "sticker" => %{"emoji" => emoji}}}
  end

  describe "answer/1" do
    test "/beep should be answered with boop" do
      expect_send_message("boop")

      message = create_message("/beep", :text)

      assert {:ok, result} = Reply.answer(message)
      assert result.body["result"]["text"] == "boop"
    end

    test "/paw should answer with a sticker" do
      expect_send_sticker(@paw_file_id)

      message = create_message("/paw", :text)

      assert {:ok, result} = Reply.answer(message)
      assert result.body["result"]["sticker"]["file_id"] == @paw_file_id
    end

    test "/cutie should answer with a sticker" do
      expect_send_sticker(@cutie_file_id)

      message = create_message("/cutie", :text)

      assert {:ok, result} = Reply.answer(message)
      assert result.body["result"]["sticker"]["file_id"] == @cutie_file_id
    end

    test "/addgame with a game's id should show the its info" do
      expect_get_game_data(
        {:ok, %{prices: "R$ 25,99 | $9.99 | No discount", title: "Garry's Mod"}}
      )

      expect_send_message(@steam_game_message)

      message = create_message("/addgame 4000", :text)

      assert {:ok, result} = Reply.answer(message)
      assert result.body["result"]["text"] == @steam_game_message
    end

    test "/addgame with an incorrect id should show a not found message" do
      expect_get_game_data({:error, :not_found})
      expect_send_message("Sorry, the ID you gave me seems invalid, maybe the ID is incorrect?")

      message = create_message("/addgame 4001", :text)

      assert {:ok, result} = Reply.answer(message)

      assert result.body["result"]["text"] ==
               "Sorry, the ID you gave me seems invalid, maybe the ID is incorrect?"
    end

    test "/deletegame with the game's id should should show a message that the game is deleted" do
      Repo.insert(@game_insert)
      expect_send_message("The game Garry's Mod has been deleted from my database!")

      message = create_message("/deletegame 4000", :text)

      refute [] == Repo.all(Game)

      assert {:ok, result} = Reply.answer(message)

      assert result.body["result"]["text"] ==
               "The game Garry's Mod has been deleted from my database!"

      assert [] == Repo.all(Game)
    end

    test "/deletegame with the game's title should should show a message that the game is deleted" do
      Repo.insert(@game_insert)
      expect_send_message("The game Garry's Mod has been deleted from my database!")

      message = create_message("/deletegame Garry's Mod", :text)

      refute [] == Repo.all(Game)

      assert {:ok, result} = Reply.answer(message)

      assert result.body["result"]["text"] ==
               "The game Garry's Mod has been deleted from my database!"

      assert [] == Repo.all(Game)
    end

    test "/deletegame with a game that's not saved in the database should show a not found message" do
      expect_send_message(
        "Sorry, I couldn't find that game in my database, maybe the id or title is incorrect?"
      )

      message = create_message("/deletegame 440", :text)

      assert {:ok, result} = Reply.answer(message)

      assert result.body["result"]["text"] ==
               "Sorry, I couldn't find that game in my database, maybe the id or title is incorrect?"
    end

    # I'll be testing the dice more thoroughly later
    test "/roll should roll a d20" do
      expect_send_message("Calculating 1d20! Result: 20")

      message = create_message("/roll 1d20", :text)

      assert {:ok, result} = Reply.answer(message)
      assert result.body["result"]["text"] == "Calculating 1d20! Result: 20"
    end

    test "doesn't send a message if no command was sent" do
      expect_send_message(:no_message)

      message = create_message("This is not a commmand", :text)

      assert :ok == Reply.answer(message)
    end

    #    I'll transform the random paw into a more consistent paw
    #    in the future.
    #
    #    test "tries to send a paw sticker when one is sent" do
    #      expect_send_sticker(@paw_file_id)
    #
    #      message = create_message("🐾", :sticker_emoji)
    #
    #      assert {:ok, result} = Reply.answer(message)
    #      assert result.body["result"]["sticker"]["file_id"] == @paw_file_id
    #    end

    test "doesn't answer random sticker" do
      expect_send_sticker(:no_sticker)

      message = create_message("🦊", :sticker_emoji)

      assert :ok == Reply.answer(message)
    end
  end
end
