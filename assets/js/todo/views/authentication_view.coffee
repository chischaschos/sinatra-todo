@App ||= {}

class App.AuthenticationView extends App.BaseView
  template: JST['todo/templates/authentication']

  events:
    'submit form'   : 'submitForm'
    'click #switch' : 'render'
    'click input'   : 'clearErrors'

  messages:
    signin:
      title: 'Enter your email and password'
      action: 'Sign In'
      other_title: 'First time user?'
    signup:
      title: 'Create an account by entering your email and password'
      action: 'Sign Up'
      other_title: 'Already have an account?'

  initialize: ->
    @signInFlow = true

  render: (event) ->
    event && event.preventDefault()
    @$el.html(@template(@selectMessages()))
    @

  selectMessages: ->
    @signInFlow = !@signInFlow
    @signInFlow && @messages.signin || @messages.signup

  submitForm: (event) ->
    event.preventDefault()
    @blockForm()
    @signInFlow && @doSignInFlow() || @doSignUpFlow()

  doSignInFlow: ->
    email = @$el.find('#email').val()
    password = @$el.find('#password').val()

    session = new App.SessionModel email: email, password: password
    session.save {},
      error: @handleError
      success: (model, response, options) =>
        @navigateToTodos()

  doSignUpFlow: ->
    email = @$el.find('#email').val()
    password = @$el.find('#password').val()

    user = new App.UserModel email: email, password: password
    user.save {},
      error: @handleError
      success: (model, response, options) =>
        @doSignInFlow()

  navigateToTodos: ->
    todoRouter.navigate('todos', trigger: true, replace: true)
