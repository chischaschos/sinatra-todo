@App ||= {}

class App.ApiDocumentationView extends App.BaseView
  template: JST['todo/templates/api_documentation']

  render: ->
    @$el.html(@template(access_token: 123))
    (new App.SessionModel).fetch
      success: (model, response, options) =>
        @$el.find("span[name='access_token']").html model.get('access_token')
    @
