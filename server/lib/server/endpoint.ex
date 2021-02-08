defmodule Server.Endpoint do

  alias Server.Utils, as: Utils
  alias Server.TodoServices, as: TodosService


  use Plug.Router

  plug Corsica,
    origins: "http://localhost:3000",
    log: [rejected: :error, invalid: :warn, accepted: :debug],
    allow_headers: ["content-type"],
    allow_credentials: true

  plug :match

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )
  plug :dispatch



  post "/todo" do
    {status, body} =
      case conn.body_params do
        %{"todo" => todo} -> case TodosService.add_todo(todo) do
          {:ok, todo} -> {200, Utils.response_todo(todo)}
          {:error, _changeset} -> {500, Utils.endpoint_error("exception")}
        end
        _ -> {400, Utils.endpoint_error("missing_data")}
      end
    send_resp(conn, status, body)
  end

  get "/todo" do
    conn
      |> send_resp(200, Utils.endpoint_success(TodosService.find_all_todo()))
  end

  put "/todo/:todo_id" do
    {status, response} = case TodosService.complete_todo(todo_id) do
      {:ok, _todo} -> {200, Utils.endpoint_success("update")}
      {:error, _changeset} -> {500, Utils.endpoint_error("exception")}
    end
    send_resp(conn, status, response)
  end

  delete "/todo/:todo_id" do
    {status, response} = case TodosService.delete_todo(todo_id) do
      {:ok, _todo} -> {200, Utils.endpoint_success("delete")}
      {:error, _changeset} -> {500, Utils.endpoint_error("exception")}
    end
    send_resp(conn, status, response)
  end

  get "/" do
    send_resp(conn, 200, Poison.encode!(%{hello: "world"}))
  end


  match _ do
    send_resp(conn, 404, "oops")
  end

end
