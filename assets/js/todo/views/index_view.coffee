@App ||= {}
class App.IndexView extends Backbone.View
  template: JST['todo/templates/index']

  render: ->
    @$el.html(@template())

