@App ||= {}
class App.TodosCollection extends Backbone.Collection

  url: '/api/list_item'

  model: App.TodoModel
