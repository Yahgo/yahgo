View = require 'views/base/view'
template = require 'views/templates/error-notifier'

module.exports = class ErrorNotifier extends View
  autoRender: true
  className: 'errorNotifier'
  region: 'errorNotifier'
  template: template


  initialize: (options) ->
    #BB doesn't get back options anymore in view
    @options = options
    @route = options.route
    that = @
    setTimeout ->
      that.$el.addClass "showMe"
    ,10

    #events
    @delegate "click", "button.left", @goBack
    @delegate "click", "button.right", @reloadPage


  #Handles error messages displayed in dialog
  getTemplateData: ->
    errorMessages =
      empty: "No items found!"
      fail: "Server error"
    errorMessages[@options.message]

  # Will close the dialog and dispose the view
  dismissDialog: (callback) ->
    @$el.removeClass "showMe"
    setTimeout =>
      @dispose()
      if callback then callback()
    ,500

  # Handles where the user will be redirected
  goBack: ->
    #first we check if history has a previous entry
    checkPrev = @route.hasOwnProperty "previous"
    # We check too if previous route was not forced Reloaded
    if checkPrev && @route.previous.action isnt "forceReload"
      path = @route.previous.path
      callback = =>

        Chaplin.utils.redirectTo {url:path}
        # Seems backbone history and chaplin history are not linked...
        #Backbone.history.navigate path, {replace: false, trigger: false}

    # No history entry ? Then, no redirection
    else
      callback = false

    @dismissDialog callback

  # Force page reload
  reloadPage: ->
    callback = =>
      # we force redirect, replace the history entry, and trigger the router
      Chaplin.utils.redirectTo {url:'forceReload/'+@route.path}, {replace: false, trigger: true}
    @dismissDialog callback

