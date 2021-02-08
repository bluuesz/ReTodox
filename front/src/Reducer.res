open Types

let reducer = (state, action: Types.action) =>
  switch (action) {
    | LOAD_TODOS(todos) =>
      { todos: todos }
    | ADD_TODO(data, name) => 
      let todos = Js.Array.concat([{ _id: data.inserted_id, name: name, completed: false }], state.todos)
      { todos: todos }
    | COMPLETE_TODO(id) => 
      let todos = Belt.Array.map(state.todos, todo => 
        if todo._id === id {
          {...todo, completed: true}
        } else {
          todo
        }
      )
      { todos: todos }
  }