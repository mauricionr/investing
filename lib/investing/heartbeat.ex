defmodule Investing.Heartbeat do
  alias Investing.Actives

  @topic "stock_updates"
  @share_url "https://statusinvest.com.br/acoes"
  @fii_url "https://statusinvest.com.br/fundos-imobiliarios"
  @etf_url "https://statusinvest.com.br/etfs"

  @doc """
  Job from quantum to get updates from statusinvest
  """
  def send do
    Actives.list_tickers_to_update 
    |> Enum.map(&update(&1))

    InvestingWeb.Endpoint.broadcast_from(self(), @topic, @topic, %{})
  end

  @doc """
  Update ticker information
  """
  def update(ticker) do
    next_update_date = Actives.last_ticker.next_update || Timex.now
    page_html = ticker |> html
    IO.inspect(ticker.name, label: "Ticker Name:")
    value =  page_html |> current_value(ticker.type |> String.downcase) |> IO.inspect(label: "Current Value:")
    variation =  page_html |> current_variation(ticker.type |> String.downcase) |> IO.inspect(label: "Current Variation:")
    dividend_yield = page_html |> current_dividend_yield(ticker.type |> String.downcase) |> IO.inspect(label: "Dividend yield:")
    pvp = page_html |> current_pvp(ticker.type |> String.downcase) |> IO.inspect(label: "P/VP:")
    next_dividend = page_html |> next_dy(ticker.type |> String.downcase) |> IO.inspect(label: "Next dividend:")
    last_dividend = page_html |> last_dy(ticker.type |> String.downcase) |> IO.inspect(label: "Last dividend:")

    ticker
    |> Actives.update_ticker(%{
      value: to_decimal(value), 
      variation: to_decimal(variation), 
      dividend_yield: to_decimal(dividend_yield),
      pvp: to_decimal(pvp),
      next_dividend: to_decimal(next_dividend),
      last_dividend: to_decimal(last_dividend),
      next_update: next_update_date |> Timex.shift(seconds: 5)
    })
  end

  defp to_decimal(""), do: nil
  defp to_decimal("-"), do: nil
  defp to_decimal(value), do: value |> String.replace(",", ".") |> String.replace("%", "") |> Decimal.new()

  defp request_by_type("fii", name) do
    HTTPoison.get("#{@fii_url}/#{name}")
  end

  defp request_by_type("share", name) do
    HTTPoison.get("#{@share_url}/#{name}")
  end

  defp request_by_type("etf", name) do
    HTTPoison.get("#{@etf_url}/#{name}")
  end

  defp html(ticker) do
    with {:ok, response} <- request_by_type(ticker.type |> String.downcase, ticker.name |> String.downcase),
      {:ok, document} <- Floki.parse_document(response.body) do
      document
    end
  end

  defp last_dy(html, "fii") do
    "#dy-info > div > div.d-flex.align-items-center > strong"
    |> from_html_to_text(html)
  end
  defp last_dy(_html, _), do: ""

  defp next_dy(html, "fii") do
    "#main-2 > div.container.pb-7 > div.mb-5.d-flex.flex-wrap.flex-lg-nowrap.justify-between > div.bg-secondary.white-text.card.w-100.w-md-45 > div > div.d-flex.align-items-center > strong"
    |> from_html_to_text(html)
  end
  defp next_dy(_html, _), do: ""

  defp current_value(html, "share") do
    "#main-2 > div:nth-child(4) > div > div.pb-3.pb-md-5 > div > div.info.special.w-100.w-md-33.w-lg-20 > div > div:nth-child(1) > strong"
    |> from_html_to_text(html)
  end

  defp current_value(html, "etf") do
    "#main-2 > div:nth-child(2) > div.top-info.mt-4.has-special.d-flex.justify-between.flex-wrap > div.info.special.w-50.w-md-25 > div > div:nth-child(1) > strong"
    |> from_html_to_text(html)
  end

  defp current_value(html, "fii") do
    "#main-2 > div.container.pb-7 > div.top-info.d-flex.flex-wrap.justify-between.mb-3.mb-md-5 > div.info.special.w-100.w-md-33.w-lg-20 > div > div:nth-child(1) > strong"
    |> from_html_to_text(html)
  end

  defp current_dividend_yield(html, "fii") do
    "#main-2 > div.container.pb-7 > div.top-info.d-flex.flex-wrap.justify-between.mb-3.mb-md-5 > div:nth-child(4) > div > div:nth-child(1) > strong"
    |> from_html_to_text(html)
  end

  defp current_dividend_yield(html, "share") do
    "#main-2 > div:nth-child(4) > div > div.pb-3.pb-md-5 > div > div:nth-child(4) > div > div:nth-child(1) > strong"
    |> from_html_to_text(html)
  end

  defp current_dividend_yield(_html, "etf") do
    ""
  end

  defp current_pvp(html, "fii") do
    "#main-2 > div.container.pb-7 > div:nth-child(3) > div > div:nth-child(2) > div > div:nth-child(1) > strong"
    |> from_html_to_text(html)
  end

  defp current_pvp(html, "share") do
    "#main-2 > div:nth-child(4) > div > div:nth-child(5) > div > div:nth-child(1) > div > div:nth-child(3) > div > div > strong"
    |> from_html_to_text(html)
  end

  defp current_pvp(_html, "etf") do
    ""
  end

  defp current_variation(html, "share") do
    "#main-2 > div:nth-child(4) > div > div.pb-3.pb-md-5 > div > div.info.special.w-100.w-md-33.w-lg-20 > div > div.w-lg-100 > span > b"
    |> from_html_to_text(html)
  end

  defp current_variation(html, "etf") do
    "#main-2 > div:nth-child(2) > div.top-info.mt-4.has-special.d-flex.justify-between.flex-wrap > div.info.special.w-50.w-md-25 > div > div.w-lg-100 > span > b"
    |> from_html_to_text(html)
  end

  defp current_variation(html, "fii") do
    "#main-2 > div.container.pb-7 > div.top-info.d-flex.flex-wrap.justify-between.mb-3.mb-md-5 > div.info.special.w-100.w-md-33.w-lg-20 > div > div.w-lg-100 > span > b"
    |> from_html_to_text(html)
  end

  defp from_html_to_text(selector, html) do
    Floki.find(html, selector) |> Floki.text()
  end
end