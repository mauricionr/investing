defmodule Investing.ActivesTest do
  use Investing.DataCase

  alias Investing.Actives

  describe "tickers" do
    alias Investing.Actives.Ticker

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def ticker_fixture(attrs \\ %{}) do
      {:ok, ticker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Actives.create_ticker()

      ticker
    end

    test "list_tickers/0 returns all tickers" do
      ticker = ticker_fixture()
      assert Actives.list_tickers() == [ticker]
    end

    test "get_ticker!/1 returns the ticker with given id" do
      ticker = ticker_fixture()
      assert Actives.get_ticker!(ticker.id) == ticker
    end

    test "create_ticker/1 with valid data creates a ticker" do
      assert {:ok, %Ticker{} = ticker} = Actives.create_ticker(@valid_attrs)
      assert ticker.name == "some name"
    end

    test "create_ticker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Actives.create_ticker(@invalid_attrs)
    end

    test "update_ticker/2 with valid data updates the ticker" do
      ticker = ticker_fixture()
      assert {:ok, %Ticker{} = ticker} = Actives.update_ticker(ticker, @update_attrs)
      assert ticker.name == "some updated name"
    end

    test "update_ticker/2 with invalid data returns error changeset" do
      ticker = ticker_fixture()
      assert {:error, %Ecto.Changeset{}} = Actives.update_ticker(ticker, @invalid_attrs)
      assert ticker == Actives.get_ticker!(ticker.id)
    end

    test "delete_ticker/1 deletes the ticker" do
      ticker = ticker_fixture()
      assert {:ok, %Ticker{}} = Actives.delete_ticker(ticker)
      assert_raise Ecto.NoResultsError, fn -> Actives.get_ticker!(ticker.id) end
    end

    test "change_ticker/1 returns a ticker changeset" do
      ticker = ticker_fixture()
      assert %Ecto.Changeset{} = Actives.change_ticker(ticker)
    end
  end
end
