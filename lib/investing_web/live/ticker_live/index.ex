defmodule InvestingWeb.TickerLive.Index do
  use InvestingWeb, :live_view

  alias Investing.Actives
  alias Investing.Actives.Ticker
  import Investing.Helpers.DateHelper, only: [to_datetime: 1]

  @topic "stock_updates"

  @impl true
  def mount(_params, _session, socket) do
    InvestingWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :tickers, list_tickers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ticker")
    |> assign(:ticker, Actives.get_ticker!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ticker")
    |> assign(:ticker, %Ticker{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tickers")
    |> assign(:ticker, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ticker = Actives.get_ticker!(id)
    {:ok, _} = Actives.delete_ticker(ticker)

    {:noreply, assign(socket, :tickers, list_tickers())}
  end

  @impl true
  def handle_event("force_update", %{"id" => id}, socket) do
    Actives.get_ticker!(id)
    |> Investing.Heartbeat.update()

    {:noreply, assign(socket, :tickers, list_tickers())}
  end

  @impl true
  def handle_info(%{event: @topic, payload: _payload}, socket) do
    {:noreply, assign(socket, :tickers, list_tickers())}
  end

  defp list_tickers do
    Actives.list_tickers()
  end
end
