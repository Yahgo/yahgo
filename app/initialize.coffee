Application = require 'application'
routes = require 'routes'
topics = require 'config/topics'
canvasHelper = require 'lib/canvas-helper'
yqlFetcher = require 'lib/yqlFetcher'

# Initialize the application on DOM ready event.
$ ->
  'use strict'

  new Application
    title: 'Yahgo',
    controllerSuffix: '-controller',
    routes: routes


  canvasHelper.windowEvents.initListeners()