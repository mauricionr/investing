defmodule Investing.Repo.Migrations.CreateTickers do
  use Ecto.Migration

  def change do
    create table(:tickers) do
      add(:name, :string)
      add(:next_update, :naive_datetime)
      add(:value, :decimal)
      add(:variation, :decimal)
      add(:type, :string)

      timestamps()
    end
    create unique_index(:tickers, [:name])
  end
end
