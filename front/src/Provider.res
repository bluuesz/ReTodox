open Types;

let initialTodo = [];

module Context = {
  include Context.Make({
    type context = (state, action => unit)

    let init = { todos: [] }

    let defaultValue = (init, _ => ())
  })
}


@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(Reducer.reducer, { todos: initialTodo })

  <Context.Provider value=(state, dispatch)> children </Context.Provider>
}