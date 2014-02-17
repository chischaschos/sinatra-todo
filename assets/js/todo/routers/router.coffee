@App ||= {}
class App.TodoRouter extends Backbone.Router
  routes:
    '' : 'index'

  index: ->
    (new App.IndexView el: $('#container')).render()
