module Title = %styled.h1(`
  font-size: 26px;
  color: #222222;
`)

@react.component 
let make = (~text) => {
  <Title>{text |> React.string}</Title>
}