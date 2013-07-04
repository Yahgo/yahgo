#routes = require 'routes'

# The application object.
module.exports = class Application extends Chaplin.Application
  # Set your application name here so the document title is set to
  # “Controller title – Site title” (see Chaplin.Layout#adjustTitle)
  title: 'Brunch example application'

  #initialize: (routes : routes) ->
  #  super
  #
  #  # Dispatcher listens for routing events and initialises controllers.
  #  @initDispatcher controllerSuffix: '-controller'
  #
  #
  #  # Freeze the application instance to prevent further changes.
  #  Object.freeze? this

  # Create additional mediator properties.
  initMediator: ->
    # Add additional application-specific properties and methods
    # e.g. Chaplin.mediator.prop = null

    # Seal the mediator.
    Chaplin.mediator.seal()
