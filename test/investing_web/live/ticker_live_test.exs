defmodule InvestingWeb.TickerLiveTest do
  use InvestingWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Investing.Actives

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:ticker) do
    {:ok, ticker} = Actives.create_ticker(@create_attrs)
    ticker
  end

  defp create_ticker(_) do
    ticker = fixture(:ticker)
    %{ticker: ticker}
  end

  describe "Index" do
    setup [:create_ticker]

    test "lists all tickers", %{conn: conn, ticker: ticker} do
      {:ok, _index_live, html} = live(conn, Routes.ticker_index_path(conn, :index))

      assert html =~ "Listing Tickers"
      assert html =~ ticker.name
    end

    test "saves new ticker", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.ticker_index_path(conn, :index))

      assert index_live |> element("a", "New Ticker") |> render_click() =~
               "New Ticker"

      assert_patch(index_live, Routes.ticker_index_path(conn, :new))

      assert index_live
             |> form("#ticker-form", ticker: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticker-form", ticker: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ticker_index_path(conn, :index))

      assert html =~ "Ticker created successfully"
      assert html =~ "some name"
    end

    test "updates ticker in listing", %{conn: conn, ticker: ticker} do
      {:ok, index_live, _html} = live(conn, Routes.ticker_index_path(conn, :index))

      assert index_live |> element("#ticker-#{ticker.id} a", "Edit") |> render_click() =~
               "Edit Ticker"

      assert_patch(index_live, Routes.ticker_index_path(conn, :edit, ticker))

      assert index_live
             |> form("#ticker-form", ticker: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticker-form", ticker: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ticker_index_path(conn, :index))

      assert html =~ "Ticker updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes ticker in listing", %{conn: conn, ticker: ticker} do
      {:ok, index_live, _html} = live(conn, Routes.ticker_index_path(conn, :index))

      assert index_live |> element("#ticker-#{ticker.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ticker-#{ticker.id}")
    end
  end

  describe "Show" do
    setup [:create_ticker]

    test "displays ticker", %{conn: conn, ticker: ticker} do
      {:ok, _show_live, html} = live(conn, Routes.ticker_show_path(conn, :show, ticker))

      assert html =~ "Show Ticker"
      assert html =~ ticker.name
    end

    test "updates ticker within modal", %{conn: conn, ticker: ticker} do
      {:ok, show_live, _html} = live(conn, Routes.ticker_show_path(conn, :show, ticker))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ticker"

      assert_patch(show_live, Routes.ticker_show_path(conn, :edit, ticker))

      assert show_live
             |> form("#ticker-form", ticker: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ticker-form", ticker: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ticker_show_path(conn, :show, ticker))

      assert html =~ "Ticker updated successfully"
      assert html =~ "some updated name"
    end
  end
end
