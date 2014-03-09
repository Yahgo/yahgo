Application = require 'application'
layoutHelper = require 'lib/layout-helper'
routes = require 'routes'

# Initialize the application on DOM ready event.
$ ->
  'use strict'

  new Application
  	title: 'Yahgo'
  	controllerSuffix: '-controller'
  	routes: routes


  layoutHelper.windowEvents.initListeners()