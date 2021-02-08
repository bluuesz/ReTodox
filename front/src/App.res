module Container = %styled.div(`
  width: 100%;

  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
`)



@react.component
let make = () => {  
  <Provider>
    <Container>
      <Form />
      <TodoList />
    </Container>
  </Provider>
}