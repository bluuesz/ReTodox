type desc_todo = {
  _id: string,
  name: string,
  completed: bool
}

type result = {
  inserted_id: string
}

type state = {
  todos: array<desc_todo>
}

type action = | LOAD_TODOS(array<desc_todo>) | ADD_TODO(result, string) | COMPLETE_TODO(string)
