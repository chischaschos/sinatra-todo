@App ||= {}
class App.TodoRouter extends Backbone.Router
  routes:
    ''        : 'index'
    'todos'   : 'todos'

  index: ->
    (new App.AuthenticationView el: $('#container')).render()

  todos: ->
    todos = new App.TodosCollection
    todos.fetch()
    #(new App.TodosView el: $('#container')).render()
