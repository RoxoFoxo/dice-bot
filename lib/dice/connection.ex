defmodule Dice.Connection do
  @callback get_updates(integer()) :: list()
  @callback send_message(integer(), String.t()) :: {:ok | :error, struct()}
  @callback send_sticker(integer(), String.t()) :: {:ok | :error, struct()}
  @adapter Application.compile_env(:dice, :connection, Dice.Connection.API)
  @moduledoc """
      Adapter for the Telegram API, made so that it can be mocked in tests.
  """

  def get_updates(offset) do
    @adapter.get_updates(offset)
  end

  def send_message(chat_id, message) do
    @adapter.send_message(chat_id, message)
  end

  def send_sticker(chat_id, sticker_id) do
    @adapter.send_sticker(chat_id, sticker_id)
  end
end
