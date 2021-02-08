module Container = %styled.div(`
  width: 480px;

  margin-top: 30px;
  height: auto;
  padding: 10px;

  background-color: #ffffff;
  border: 1px solid #222222;
  color: #000;

  display: flex;
  align-items: center;

  border-top-right-radius: 4px;
  border-bottom-right-radius: 4px;
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;

  cursor: pointer;
`)

module Content = %styled.h3(`
  font-size: 20px;
`)

module Done = %styled.span(
  (~color) =>
    j`
  color: $color;
  margin-left: auto;
`
)


@react.component
let make = (~name, ~isComplete, ~id) => {
  let (_, dispatch) = Provider.Context.useTodo();

  let onCompleteTodo = (id) => {

    let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})

    let url = "http://localhost:8180/todo/" ++ id;

    let _ = Fetch.fetchWithInit(url, 
      Fetch.RequestInit.make(
        ~method_=Put,
        ~headers=headers,
        (),
      ),
    )->Js.Promise.then_(Fetch.Response.json, _)
    ->Js.Promise.then_(_ => dispatch(COMPLETE_TODO(id))->Js.Promise.resolve, _)
  } 

  <Container onClick={_ => onCompleteTodo(id)}>
   <Content>{name->React.string}</Content>
    <Done color={isComplete ? "green" : "tomato"} >{"completed"->React.string}</Done>
  </Container>
}