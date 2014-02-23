@App ||= {}
class App.AuthenticationView extends Backbone.View
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

  render: ->
    @$el.html(@template(@selectMessages()))

    return false

  selectMessages: ->
    @signInFlow = !@signInFlow
    @signInFlow && @messages.signin || @messages.signup

  submitForm: ->
    @blockForm()
    @sendForm()
    false

  blockForm: ->
    @$el.find('input').attr('disabled', 'disabled')

  unblockForm: ->
    @$el.find('input').removeAttr('disabled')

  sendForm: ->
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

  handleError: (model, response, options) =>
    @cleanErrors()
    default_error_container = @$el.find('#messages')

    for key, value of @getErrors(response)
      error_elements =  @$el.find("##{key}_error")

      if error_elements.length > 0
        error_elements.show().append(value);

      else
        default_error_container.show().append(value);

    @unblockForm()

   getErrors: (response) ->
     if response.responseJSON && !_.isEmpty(response.responseJSON.errors)
       response.responseJSON.errors
     else
       { default: 'Unknown error' }

   cleanErrors: ->
     @$el.find("[name=error]").html('')
