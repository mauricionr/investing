defmodule InvestingWeb.Router do
  use InvestingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {InvestingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvestingWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/tickers", TickerLive.Index, :index
    live "/tickers/new", TickerLive.Index, :new
    live "/tickers/:id/edit", TickerLive.Index, :edit

    live "/tickers/:id", TickerLive.Show, :show
    live "/tickers/:id/show/edit", TickerLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", InvestingWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: InvestingWeb.Telemetry
    end
  end
end
