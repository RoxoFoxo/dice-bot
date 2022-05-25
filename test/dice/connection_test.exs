defmodule Dice.ConnectionTest do
  use Dice.DataCase

  import Dice.Expectations

  alias Dice.Connection

  describe "get_updates/1" do
    test "tests if the adapter is working properly" do
      expect_get_updates(["adapter_test"])

      assert ["adapter_test"] == Connection.get_updates(1)
    end
  end

  describe "send_message/2" do
    test "tests if the adapter is working properly" do
      expect_send_message("message_adapter_test")

      assert {:ok, result} = Connection.send_message(69, "message_adapter_test")
      assert result.body["result"]["text"] == "message_adapter_test"
    end
  end

  describe "send_sticker/2" do
    test "tests if the adapter is working properly" do
      expect_send_sticker("sticker_adapter_test")

      assert {:ok, result} = Dice.Connection.send_sticker(420, "sticker_adapter_test")
      assert result.body["result"]["sticker"]["file_id"] == "sticker_adapter_test"
    end
  end
end
