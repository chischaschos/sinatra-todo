@App ||= {}
class App.SessionModel extends Backbone.Model

  initialize: ->
    @id = 1

  url: ->
    '/api/session'

  toJSON: ->
    user: _.clone(@attributes)
