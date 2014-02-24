@App ||= {}
class App.NewTodoView extends App.BaseView
  template: JST['todo/templates/new_todo']

  events:
    'click #cancel-todo'    : 'back'
    'submit #add-todo-form' : 'submitForm'
    'change input'          : 'changed'

  initialize: (options) ->
    @parent = options.parent
    if options.model
      @edit = true
      @model = options.model
    else
      @edit = false
      @model = new App.TodoModel

  back: (event) ->
    event && event.preventDefault()
    @remove()
    @parent.render()

  render: ->
    @$el.html(@template(@model.toJSON().list_item))
    @

  changed: (event) ->
     changed = event.currentTarget
     value = $(changed).val()
     attributes = {}
     attributes[changed.id] = value
     @model.set(attributes)

  submitForm: (event) ->
    event.preventDefault()
    @blockForm()

    @model.save {},
      success: (model, response, options) =>
        @back()
      error: @handleError
