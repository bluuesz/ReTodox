defmodule Server.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Server.Endpoint, options: [port: 8180]},
      {Mongo, [name: :mongo, database: "todo", pool_size: 2, url: "mongodb://dev:dev123@localhost:27017/todo?authSource=admin"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Server.Supervisor]

    Logger.info("Server start at port 8180...")


    Supervisor.start_link(children, opts)
  end
end
