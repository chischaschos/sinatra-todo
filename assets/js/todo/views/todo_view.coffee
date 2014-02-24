@App ||= {}
class App.TodoView extends App.BaseView
  template: JST['todo/templates/todo']

  tagName: 'tr'

  events:
    'click .todo-remove' : 'destroy'
    'click .todo-edit'   : 'edit'

  initialize: (options) ->
    @model = options.model
    @parent = options.parent

  render: ->
    @$el.html(@template(@model.toJSON().list_item))
    @

  destroy: (event) =>
    event.preventDefault()
    @model.destroy()
    @remove()

  edit: (event) =>
    event.preventDefault()
    @parent.editTodo(@model)

