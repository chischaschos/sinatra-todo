@App ||= {}
class App.TodoRouter extends Backbone.Router
  initialize: ->
    @container = $('#container')

  switchView: (view) ->
    @currentView && @currentView.remove()
    @currentView = view
    @container.html(@currentView.render().el)

  routes:
    ''         : 'authenticate'
    'todos'    : 'todos'
    'sign-out' : 'signOut'
    'api-doc'   : 'apiDocumentation'

  authenticate: ->
    @switchView(new App.AuthenticationView)

  todos: ->
    todosView = new App.TodosView
      collection: new App.TodosCollection
    @switchView(todosView)

  signOut: ->
    (new App.SessionModel id: 1).destroy
      wait: true
      error: (model, response, options) ->
        todoRouter.navigate('', trigger: true, replace: true)
      success: (model, response, options) ->
        todoRouter.navigate('', trigger: true, replace: true)

  apiDocumentation: ->
    @switchView(new App.ApiDocumentationView)
