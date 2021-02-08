open Types

module FormContainer = %styled.div(`
  margin-top: 50px;
`)

module Form = %styled.form(`
  margin-top: 30px;
  display: flex;
`)

module Button = %styled.button(`
  width: 130px;
  height: 45px;
  background-color: #008000;
  color: #fff;
  font-weight: 600;
  align-items: center;

  border-top-right-radius: 4px;
  border-bottom-right-radius: 4px;
`)

let inputClassName = %css(`
  width: 350px;
  height: 45px;
  background-color: #fff;
  color: #222;
  padding: 0 10px;
  border: 2px solid #9999;
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
`)



type response = {
  response: Types.result
}



module Decode = {
  open Json.Decode;

  let decodeTodo = json => {
    _id: field("_id", string, json),
    name: field("name", string, json),
    completed: field("completed", bool, json)
  };

  let decodeAdd = json => {
    inserted_id: field("inserted_id", string, json)
  };

  let add = json => {
    response: field("response", decodeAdd, json)
  };

  let todos = json => {
    todos: field("todos", array(decodeTodo), json)
  }
};

module Encode = {
  let encodeTodo = (name) : Js.Json.t  => {
    open Json.Encode;
    object_(list{
      ("todo", string(name))
    })
  }


}

let fetchTodos = () =>
    Fetch.fetch("http://localhost:8180/todo")
    |> Js.Promise.then_(Fetch.Response.json)
    |> Js.Promise.then_(json =>
         json |> Decode.todos |> (todos => Some(todos) |> Js.Promise.resolve)
       )
    |> Js.Promise.catch(_err => Js.Promise.resolve(None))



@react.component
let make = () => {
  let (_, dispatch) = Provider.Context.useTodo();
  let (name, setName) = React.useState(_ => "");


  let onChange = e => {
    ReactEvent.Form.preventDefault(e);
    let value = ReactEvent.Form.target(e)["value"];
    setName(_prev => value);
  }

  let onSubmit = (e) => {
    ReactEvent.Mouse.preventDefault(e)

    let body = name->Encode.encodeTodo->Json.stringify->Fetch.BodyInit.make;

    let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})

    let _ = Fetch.fetchWithInit("http://localhost:8180/todo", 
      Fetch.RequestInit.make(
        ~method_=Post,
        ~body=body,
        ~headers=headers,
        (),
      ),
    )->Js.Promise.then_(Fetch.Response.json, _)
    ->Js.Promise.then_(response =>Decode.add(response)
    ->Js.Promise.resolve, _)
    ->Js.Promise.then_(data => dispatch(ADD_TODO(data.response, name))->Js.Promise.resolve, _)
    
    setName(_prev => "")
  }

  React.useEffect0(() => {
    let _ = fetchTodos()->Js.Promise.then_(result => switch (result) {
      | Some(data) => dispatch(LOAD_TODOS(data.todos))
      | None => Js.log("Fetch todos failure!")
    }->Js.Promise.resolve, _)

    None
  })

  <FormContainer>
    <Title text="Adicionar to-do" />

    <Form>
      <input onChange className=inputClassName value=name type_="text" placeholder="nome do seu to-do" />
      <Button onClick=onSubmit type_="submit" >{"Adicionar" |> React.string}</Button>
    </Form>

  </FormContainer>
}