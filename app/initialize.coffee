Application = require 'application'
routes = require 'routes'
topics = require 'config/topics'

# Initialize the application on DOM ready event.
$ ->
  
  new Application
    title: 'Brunch example application',
    controllerSuffix: '-controller',
    routes: routes