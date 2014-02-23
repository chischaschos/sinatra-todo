@App ||= {}
class App.UserModel extends Backbone.Model

  urlRoot: '/api/users'

  toJSON: ->
    user: _.clone(@attributes)
