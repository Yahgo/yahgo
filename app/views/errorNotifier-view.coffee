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
    @history = options.history
    console.log @history
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
    #first we check if history contains at least an entry
    historyLength = @history.collection.length
    if historyLength > 0
      # Grab path from model in collection
      path = @history.collection.at(historyLength - 1).get "path"
      callback = =>

        Chaplin.utils.redirectTo {url:path}
        # Seems backbone history and chaplin history are not linked,
        # so for now we can't use simply that :
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

