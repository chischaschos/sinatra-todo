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

  helpers:
    isChecked: (status) ->
      status && "checked" || ""

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
      @messages[@type],
      @helpers
    )
    @$el.html(@template(attributes))
    @$el.find("#priority").mask("9")
    @$el.find("#due_date").mask("9999-99-99")
    @

  changed: (event) ->
    changed = $(event.currentTarget)
    attributes = {}
    if changed.attr('type') is 'checkbox'
      attributes[changed.attr('id')] = changed.prop('checked')
    else
      attributes[changed.attr('id')] = changed.val()
    @model.set(attributes)

  submitForm: (event) ->
    event.preventDefault()
    @blockForm()

    @model.save {},
      success: (model, response, options) =>
        @back()
      error: @handleError
