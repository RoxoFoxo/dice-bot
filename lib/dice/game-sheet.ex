defmodule Dice.GameSheet do
  @moduledoc """
    The Gamesheet context, which handles the Game schema
    and creates its related messages.
  """
  import Ecto.Query, warn: false

  alias Dice.GameSheet.Game
  alias Dice.Repo
  alias Dice.SteamClient

  # def add_game(attrs \\ %{}) do
  #   %Game{}
  #   |> Game.changeset(attrs)
  #   |> Repo.insert()
  # end

  @doc """
    Input is the games' id on the steam store and
    the user id of who suggested it in the message.
  """
  def add_steam_game(steam_game_id, user_id) do
    {_ok, game_info} = steam_result = SteamClient.get_game_data(steam_game_id)

    with nil <- Repo.get_by(Game, steam_id: steam_game_id),
         {:ok, _game_info} <- steam_result do
      attrs = %{title: game_info.title, steam_id: steam_game_id, suggester: user_id}

      %Game{}
      |> Game.changeset(attrs)
      |> Repo.insert()

      Map.put_new(game_info, :suggester, user_id)
    else
      %Game{} = game ->
        Map.put_new(game_info, :suggester, game.suggester)

      {:error, reason} ->
        {:error, reason}
    end
    |> handle_game_info(steam_game_id)
  end

  defp handle_game_info(game_info, steam_game_id) do
    case game_info do
      %{} ->
        """
        #{game_info.title} | Suggested by: <a href="tg://user?id=#{game_info.suggester}">this person</a>
        #{game_info.prices}
        https://store.steampowered.com/app/#{steam_game_id}
        """

      {:error, :not_found} ->
        "Sorry, the ID you gave me seems invalid, maybe the ID is incorrect?"

      _ ->
        "Sorry, seems like there is an unknown error, maybe Steam is down?"
    end
  end

  def delete_game(game_detail) do
    with nil <- Repo.get_by(Game, steam_id: game_detail),
         nil <- Repo.get_by(Game, title: game_detail) do
      "Sorry, I couldn't find that game in my database, maybe the id or title is incorrect?"
    else
      %Game{} = game ->
        GameSheet.delete_game(game)

        "The game #{game.title} has been deleted from my database!"
    end
  end
end
