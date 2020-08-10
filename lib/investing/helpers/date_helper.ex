defmodule Investing.Helpers.DateHelper do
  @moduledoc "Helper to format dates"

  use Timex

  @datetime_format "%d/%m/%Y %H:%M:%S"
  @date_format "%d/%m/%Y"
  @time_format "%H:%M:%S"

  def to_date(date) when not is_nil(date) do
    date
    |> parse_date()
    |> Timex.format!(@date_format, :strftime)
  end

  def to_date(nil), do: nil

  def to_time(date) do
    date
    |> parse_date()
    |> Timex.format!(@time_format, :strftime)
  end

  def to_datetime(date) do
    date
    |> parse_date()
    |> Timex.format!(@datetime_format, :strftime)
  end

  def parse_date(nil), do: nil
  def parse_date(date), do: Timex.to_datetime(date)
end
