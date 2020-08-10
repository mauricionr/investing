defmodule Investing.Repo do
  use Ecto.Repo,
    otp_app: :investing,
    adapter: Ecto.Adapters.Postgres
end
