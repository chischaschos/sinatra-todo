@App ||= {}
class App.TodosView extends App.BaseView
  template: JST['todo/templates/todos']

  events:
    'click #add-todo'  : 'createTodo'

  initialize: (options) ->
    @collection = options.collection
    @collection.on('reset', @displayAll)
    @collection.on('add', @addOne)

  displayAll: (todos) =>
    todos.forEach (todo) =>
      @addOne(todo)

  addOne: (model) =>
    todoView = new App.TodoView
      model: model
      parent: @
    @$el.find('#todos').append(todoView.render().el)

  createTodo: (event) ->
    event.preventDefault()
    newTodoView = new App.NewTodoView
      parent: @
    @$el.find('#todos').html(newTodoView.render().el)

  editTodo: (model) ->
    newTodoView = new App.NewTodoView
      parent: @
      model: model
    @$el.find('#todos').html(newTodoView.render().el)

  render: ->
    @collection.fetch(reset: true)
    @$el.html(@template())
    @
