defmodule Investing.Repo.Migrations.AddDivedendInfoToTickers do
  use Ecto.Migration

  def change do
    alter table(:tickers) do
      add(:next_dividend, :decimal)
      add(:last_dividend, :decimal)
    end
  end
end
