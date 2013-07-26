Application = require 'application'
routes = require 'routes'
topics = require 'config/topics'

# Initialize the application on DOM ready event.
$ ->
  'use strict'
  
  new Application
    title: 'Yahgo',
    controllerSuffix: '-controller',
    routes: routes