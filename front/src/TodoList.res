@react.component
let make = () => {
  let (state, _) = Provider.Context.useTodo();

  <>
    {state.todos -> Belt.Array.map(todo => 
      <Todo key=todo._id name=todo.name isComplete=todo.completed id=todo._id />) 
      -> ReasonReact.array}
  </>
}