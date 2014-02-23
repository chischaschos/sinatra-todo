@App ||= {}
class App.TodoView extends Backbone.View
  template: JST['todo/templates/todo']

  tagName: 'ul'

  events:
    'click .todo-remove' : 'destroy'
    'click .todo-edit'   : 'edit'

  initialize: (options) ->
    @model = options.model
    @parent = options.parent

  render: ->
    @$el.html(@template(@model.toJSON()))

  destroy: (event) =>
    event.preventDefault()
    @model.destroy()
    @remove()

  edit: (event) =>
    event.preventDefault()
    @parent.editTodo(@model)

