@App ||= {}
class App.SessionModel extends Backbone.Model

  urlRoot: '/api/session'

  toJSON: ->
    user: _.clone(@attributes)
