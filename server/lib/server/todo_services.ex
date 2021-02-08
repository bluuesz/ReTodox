defmodule Server.TodoServices do
  def add_todo(todo) do
    case Mongo.insert_one(:mongo, "todo", %{ name: todo, completed: false }) do
      {:ok, todo} -> {:ok, todo}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp obejctId(id) do
    BSON.ObjectId.decode!(id)
  end

  def delete_todo(todo_id) do
    case Mongo.delete_one(:mongo, "todo", %{ _id: obejctId(todo_id) }) do
      {:ok, todo} -> {:ok, todo}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def find_all_todo do
    cursor = Mongo.find(:mongo, "todo", %{})

    cursor
      |> Enum.to_list()
      |> handle_todo_db()
  end

  def complete_todo(todo_id) do
    case Mongo.find_one_and_update(:mongo, "todo", %{ _id: obejctId(todo_id) }, %{"$set": %{ completed: true }}) do
      {:ok, todo} -> {:ok, todo}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def handle_todo_db(todos) do
    if Enum.empty?(todos) do
      []
    else
      todos
    end
  end

end
