@App ||= {}
class App.TodoRouter extends Backbone.Router
  initialize: ->
    @container = $('#container')

  routes:
    ''        : 'authenticate'
    'todos'   : 'todos'

  authenticate: ->
    authenticationView = new App.AuthenticationView el: @container
    authenticationView.render()

  todos: ->
    todosView = new App.TodosView
      el: @container
      collection: new App.TodosCollection
    todosView.render()
