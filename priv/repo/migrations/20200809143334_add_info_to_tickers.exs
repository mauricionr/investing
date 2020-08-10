defmodule Investing.Repo.Migrations.AddInfoToTickers do
  use Ecto.Migration

  def change do
    alter table(:tickers) do
      add(:pvp, :decimal)
      add(:dividend_yield, :decimal)
    end
  end
end
