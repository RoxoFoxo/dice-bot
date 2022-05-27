defmodule Dice.SteamClient do
  @callback get_game_data(String.t()) :: {:ok | :error, tuple() | atom(), String.t()}
  @adapter Application.compile_env(:dice, :steam_client, Dice.SteamClient.API)

  def get_game_data(game_id) do
    @adapter.get_game_data(game_id)
  end
end
