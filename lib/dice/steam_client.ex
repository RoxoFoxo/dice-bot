defmodule Dice.SteamClient do
  @moduledoc """
  This module is an adapter so the API is able to be mocked.
  """
  @callback get_game_data(String.t()) :: {:ok | :error, map() | atom()}
  @adapter Application.compile_env(:dice, :steam_client, Dice.SteamClient.API)

  def get_game_data(game_id) do
    @adapter.get_game_data(game_id)
  end
end
