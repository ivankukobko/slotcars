Shared.User = DS.Model.extend

  username: DS.attr 'string'
  email: DS.attr 'string'
  password: DS.attr 'string'

Shared.User.reopenClass

  current: null

  signUp: (credentials) ->
    user = Shared.User.createRecord credentials
    Shared.ModelStore.commit()

  signIn: (credentials, successCallback, errorCallback) ->

    data =
      remote: true
      utf8: "✓"
      user: credentials

    jQuery.ajax "/api/sign_in",
      type: "POST"
      dataType: 'json'
      data: data

      success: (response) ->
        userData = response.user
        Shared.ModelStore.load Shared.User, userData

        Shared.User.current = Shared.User.find userData.id

        successCallback Shared.User.current if successCallback?

      error: (response) -> errorCallback() if errorCallback?

  signOutCurrentUser: (successCallback, errorCallback) ->

    if @current?
      jQuery.ajax "/api/sign_out",
        success: ->
          Shared.User.current = null
          successCallback()

        error: -> errorCallback()