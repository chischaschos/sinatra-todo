@App ||= {}
class App.TodosCollection extends Backbone.Collection

  url: '/api/list_item'
