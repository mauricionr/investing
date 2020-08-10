defmodule Investing.Actives.Ticker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickers" do
    field :name, :string
    field :type, :string
    field :value, :decimal
    field :variation, :decimal
    field :pvp, :decimal
    field :dividend_yield, :decimal
    field :next_dividend, :decimal
    field :last_dividend, :decimal
    field :next_update, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(ticker, attrs) do
    ticker
    |> cast(attrs, [
      :name, 
      :next_update, 
      :value, 
      :variation, 
      :type,
      :pvp,
      :dividend_yield,
      :next_dividend,
      :last_dividend
    ])
    |> validate_required([:name, :type])
    |> unique_constraint(:name)
  end
end
