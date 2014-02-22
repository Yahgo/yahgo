Application = require 'application'
canvasHelper = require 'lib/canvas-helper'
routes = require 'routes'

# Initialize the application on DOM ready event.
$ ->
  'use strict'

  new Application
  	title: 'Yahgo'
  	controllerSuffix: '-controller'
  	routes: routes


  canvasHelper.windowEvents.initListeners()