defmodule Platform.AccountsTest do
  use Platform.DataCase

  alias Platform.Accounts

  describe "players" do
    alias Platform.Accounts.Player

    @valid_attrs %{password: "some password", username: "some username"}
    @update_attrs %{display_name: "some updated display name", password: "some updated password", score: 43, username: "some updated username"}
    @invalid_attrs %{password: nil, username: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_player()

      player_attrs_map =
        player
        |> Map.from_struct()
        |> Map.delete(:password)

      %Platform.Accounts.Player{}
      |> Map.merge(player_attrs_map)
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Accounts.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Accounts.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Accounts.create_player(@valid_attrs)
      assert player.password == "some password"
      assert player.username == "some username"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, player} = Accounts.update_player(player, @update_attrs)
      assert %Player{} = player
      assert player.display_name == "some updated display name"
      assert player.score == 43
      #assert player.password == "some updated password"
      assert player.username == "some updated username"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_player(player, @invalid_attrs)
      assert player == Accounts.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Accounts.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Accounts.change_player(player)
    end
  end
end
