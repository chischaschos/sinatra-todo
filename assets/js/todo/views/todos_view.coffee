@App ||= {}
class App.TodosView extends Backbone.View
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
    @$el.find('#todos').append todoView.render()

  createTodo: (event) ->
    event.preventDefault()
    newTodoView = new App.NewTodoView
      el: @$el.find('#todos')
      parent: @
    newTodoView.render()

  editTodo: (model) ->
    newTodoView = new App.NewTodoView
      el: @$el.find('#todos')
      parent: @
      model: model
    newTodoView.render()


  render: ->
    @$el.html(@template())
    @collection.fetch(reset: true)

