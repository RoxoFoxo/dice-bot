defmodule Dice.GameSheet do
  @moduledoc """
    The Gamesheet context, which handles the Game schema
    and creates its related messages.
  """
  import Ecto.Query, warn: false

  alias Dice.GameSheet.Game
  alias Dice.GameSheet.UsersGames
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
  def add_steam_game(game_id, telegram_id) do
    {_ok, game_info} = steam_result = SteamClient.get_game_data(game_id)

    with nil <- Repo.get_by(Game, id: game_id),
         {:ok, _game_info} <- steam_result do
      attrs = %{title: game_info.title, id: game_id, suggester: telegram_id}

      %Game{}
      |> Game.changeset(attrs)
      |> Repo.insert()

      %{game_id: game_id, user_id: telegram_id}
      |> create_user_game_association()

      Map.put_new(game_info, :suggester, telegram_id)
    else
      %Game{} = game ->
        Map.put_new(game_info, :suggester, game.suggester)

      {:error, reason} ->
        {:error, reason}
    end
    |> handle_game_info(game_id)
  end

  defp handle_game_info(game_info, game_id) do
    case game_info do
      %{} ->
        """
        #{game_info.title} | Suggested by: <a href="tg://user?id=#{game_info.suggester}">this person</a>
        #{game_info.prices}
        https://store.steampowered.com/app/#{game_id}
        """

      {:error, :not_found} ->
        "Sorry, the ID you gave me seems invalid, maybe the ID is incorrect?"

      _ ->
        "Sorry, seems like there is an unknown error, maybe Steam is down?"
    end
  end

  def delete_game(game_detail) do
    case get_game_by_id_or_title(game_detail) do
      nil ->
        "Sorry, I couldn't find that game in my database, maybe the id or title is incorrect?"

      %Game{} = game ->
        Repo.delete(game)

        "The game #{game.title} has been deleted from my database!"
    end
  end

  defp create_user_game_association(attrs) do
    %UsersGames{}
    |> UsersGames.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_game_association(user_id, game_detail, attrs) do
    with %Game{} = game <- get_game_by_id_or_title(game_detail),
         {:ok, assoc} <- get_association(user_id, game.id) do
      assoc
      |> UsersGames.changeset(attrs)
      |> Repo.update()

      "I have updated if you own/like #{game.title}!"
    else
      nil ->
        "Sorry, I couldn't find that game in my database, maybe the id or title is incorrect?"
    end
  end

  defp get_game_by_id_or_title(game_detail) when is_integer(game_detail) do
    Repo.get_by(Game, id: game_detail)
  end

  defp get_game_by_id_or_title(game_detail) do
    Repo.get_by(Game, title: game_detail)
  end

  defp get_association(user_id, game_id) do
    attrs = %{user_id: user_id, game_id: game_id}

    case Repo.get_by(UsersGames, attrs) do
      nil ->
        create_user_game_association(attrs)

      assoc ->
        {:ok, assoc}
    end
  end
end
