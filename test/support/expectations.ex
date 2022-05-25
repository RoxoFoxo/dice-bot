defmodule Dice.Expectations do
  @moduledoc false
  import Hammox

  def expect_get_updates(result) do
    Dice.Connection.Mock
    |> expect(:get_updates, fn _ -> result end)
  end

  def expect_send_message(:no_message) do
    Dice.Connection.Mock
    |> Hammox.expect(:send_message, 0, fn _, _ -> "Fennec" end)
  end

  def expect_send_message(text) do
    Dice.Connection.Mock
    |> expect(:send_message, fn _, _ ->
      {:ok, %Tesla.Env{body: %{"result" => %{"text" => text}}}}
    end)
  end

  def expect_send_sticker(:no_sticker) do
    Dice.Connection.Mock
    |> expect(:send_sticker, fn _, _ -> "Fox" end)
  end

  def expect_send_sticker(sticker) do
    Dice.Connection.Mock
    |> expect(:send_sticker, fn _, _ ->
      {:ok, %Tesla.Env{body: %{"result" => %{"sticker" => %{"file_id" => sticker}}}}}
    end)
  end
end
