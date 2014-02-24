@App ||= {}
class App.TodosView extends App.BaseView
  template: JST['todo/templates/todos']

  events:
    'click #add-todo'          : 'createTodo'
    'click #order-by-priority' : 'orderByPriority'
    'click #order-by-due_date' : 'orderByDueDate'

  order:
    sort_by: 'due_date'
    ord:     'asc'

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
    @$el.find('#todos tbody').append(todoView.render().el)

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
    @collection.fetch
      reset: true
      data: @order
    @$el.html(@template())
    @

  orderByDueDate: (event) =>
    event.preventDefault()
    @order.sort_by = 'due_date'
    @order.ord = @order.ord is 'asc' && 'desc' || 'asc'
    @render()

  orderByPriority: (event) =>
    event.preventDefault()
    @order.sort_by = 'priority'
    @order.ord = @order.ord is 'asc' && 'desc' || 'asc'
    @render()

