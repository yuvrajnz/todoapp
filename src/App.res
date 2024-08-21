%%raw("import './App.css'")
type todo = {
  id: int,
  content: string,
  completed: bool,
}

type action =
  | AddTodo(string)
  | RemoveTodo(int)
  | ToggleTodo(int)


type state = {
  todos: array<todo>,
  nextId: int,
}

let reducer = (state, action) =>
  switch action {
  | AddTodo(content) =>
    let todos = Array.concat(
      state.todos,
      [{id: state.nextId, content: content, completed: false}],
    )
    {todos: todos, nextId: state.nextId + 1}
  | RemoveTodo(id) =>
    let todos = Array.filter(state.todos, todo => todo.id !== id)
    {...state, todos: todos}
  | ToggleTodo(id) =>
    let todos = Belt.Array.map(state.todos, todo =>
      if todo.id === id {
        {
          ...todo,
          completed: !todo.completed,
        }
      } else {
        todo
      }
    )
    {...state, todos: todos}
  }

let initialTodos = [{id: 1, content: "Task 1", completed: false}]

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(
    reducer,
    {todos: initialTodos, nextId: 2},
  )
  let (newTodo, setNewTodo) = React.useState(() => "")
  let handleAddTodo = (evt) => {
    ReactEvent.Form.preventDefault(evt);
    if (newTodo !== "") {
      setNewTodo(ReactEvent.Form.target(evt)["value"]);
      dispatch(AddTodo(newTodo));
      setNewTodo(_prev => "");
    }
  }

  let handleChange =(event)=>{
      ReactEvent.Form.preventDefault(event);
      let value = ReactEvent.Form.target(event)["value"];
      setNewTodo(_prev => value);
  } 

  let todos = Belt.Array.map(state.todos, todo =>
    <li>
      <input
        type_="checkbox"
        checked=todo.completed
        onChange={_ => dispatch(ToggleTodo(todo.id))}
      />
      {React.string(todo.content)}
      <button onClick={_ => dispatch(RemoveTodo(todo.id))}>
        {React.string("remove")}
      </button>
    </li>
  )

  <>
    <h1> {React.string("Todo List:")} </h1>
    <ul> {React.array(todos)} </ul>
    <form onSubmit=handleAddTodo>
      <input
        type_="text"
        value=newTodo
        onChange = {
          event => handleChange(event)  
        }
      />
      <button type_="submit">{React.string("Add Todo")}</button>
    </form>
  </>
}

