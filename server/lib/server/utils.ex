defmodule Server.Utils do
  defimpl Poison.Encoder, for: BSON.ObjectId do
    def encode(id, options) do
      BSON.ObjectId.encode!(id)
      |> Poison.Encoder.encode(options)
    end
  end



  def endpoint_success(data) do
    Poison.encode!(%{
      "todos" =>
      cond do
        data == "delete" -> "Deleted with success"
        data == "update" -> "Update with success"
        true -> data
      end
    })
  end

  def response_todo(data) do
    Poison.encode!(%{
      "response" => data
    })
  end

  def endpoint_error(error_type) do
    Poison.encode!(%{
      "fail_reason" =>
        cond do
          error_type == "empty" -> "Empty Data"
          error_type == "not_found" -> "Not found"
          error_type == "missing_data" -> "Missing query params"
          error_type == "missing_data_todo_id" -> "Missing todo_id"
          true -> IO.puts error_type
        end
    })
  end
end
