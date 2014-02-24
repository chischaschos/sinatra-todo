@App ||= {}
class App.NewTodoView extends App.BaseView
  template: JST['todo/templates/new_todo']

  events:
    'click #cancel-todo'    : 'back'
    'submit #add-todo-form' : 'submitForm'
    'change input'          : 'changed'

  messages:
    edit:
      title:  'Editing TODO item'
      action: 'Save'
    new:
      title:  'Creating new TODO item'
      action: 'Create'

  initialize: (options) ->
    @parent = options.parent
    if options.model
      @type = 'edit'
      @model = options.model
    else
      @type = 'new'
      @model = new App.TodoModel

  back: (event) ->
    event && event.preventDefault()
    @remove()
    @parent.render()

  render: ->
    attributes = _.extend(
      {},
      @model.toJSON().list_item,
      @messages[@type]
    )
    @$el.html(@template(attributes))
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
