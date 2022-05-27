defmodule Dice.SteamClient.API do
  @moduledoc """
    Module to call Steam's API to get data from store pages.
  """
  @behaviour Dice.SteamClient
  use Tesla

  require Logger

  plug(
    Tesla.Middleware.BaseUrl,
    "https://store.steampowered.com/api/"
  )

  plug(Tesla.Middleware.JSON)

  # game_id has to be a string
  def get_game_data(game_id) do
    with {:ok, result_br} <- get("appdetails?appids=#{game_id}&cc=br"),
         {:ok, result_us} <- get("appdetails?appids=#{game_id}&cc=us"),
         %{"success" => true, "data" => data_br} <- result_br.body[game_id],
         %{"success" => true, "data" => data_us} <- result_us.body[game_id] do
      Logger.debug(inspect(result_br))
      Logger.debug(inspect(result_us))

      # %{"success" => true, "data" => data_br} = body_br[game_id]
      # %{"success" => true, "data" => data_us} = body_us[game_id]

      game_name = data_us["name"]

      if data_us["is_free"] do
        {:ok, :free, game_name}
      else
        price_br = get_price(data_br)
        price_us = get_price(data_us)
        discount = get_discount(data_us)

        {:ok, {price_br, price_us, discount}, game_name}
      end
    else
      %{"success" => false} ->
        {:error, :not_found}

      error ->
        Logger.error(inspect(error))
        {:error, :unknown_error}
    end
  end

  defp get_price(%{"price_overview" => %{"final_formatted" => price}}) do
    price
  end

  defp get_discount(%{"price_overview" => %{"discount_percent" => discount}}) do
    if discount == 0 do
      "No discount"
    else
      "#{discount}%"
    end
  end
end
