defmodule Investing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Investing.Repo,
      # Start the Telemetry supervisor
      InvestingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Investing.PubSub},
      # Start the Endpoint (http/https)
      InvestingWeb.Endpoint,
      Investing.Scheduler
      # Start a worker by calling: Investing.Worker.start_link(arg)
      # {Investing.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Investing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InvestingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
