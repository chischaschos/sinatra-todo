@App ||= {}
class App.TodoModel extends Backbone.Model
  urlRoot: '/api/list_item'

  defaults:
    description: null
    priority:    null
    completed:   null
    due_date:    null

  toJSON: ->
    list_item: _.clone(@attributes)
