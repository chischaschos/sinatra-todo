@App ||= {}

@App.ErrorHandlingHelpers =
  blockForm: ->
    @$el.find('input').attr('disabled', 'disabled')

  unblockForm: ->
    @$el.find('input').removeAttr('disabled')

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
