defmodule Dice.ReplyTest do
  use Dice.DataCase

  import Dice.Expectations

  alias Dice.Reply

  @paw_file_id "CAACAgEAAxkBAANeYBCKLIhaKQwOobteRP3a5quwUsIAAh8AAxeZ2Q7IeDvomNaN1B4E"
  @cutie_file_id "CAACAgEAAxkBAANyYBDao0rvEg4hd3aH-JM7qRAVXQQAAgUAA5T5DDXKWqGUl7FB1R4E"

  def create_message(text, :text) do
    %{"message" => %{"chat" => %{"id" => 1_001_251_536}, "text" => text}}
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
