Application = require 'application'
routes = require 'routes'
topics = require 'config/topics'
canvasHelper = require 'lib/canvas-helper'

# Initialize the application on DOM ready event.
$ ->
  'use strict'
  
  new Application
    title: 'Yahgo',
    controllerSuffix: '-controller',
    routes: routes
  ###
    Test for canvas resizing. Comment lines below if want to revert to img tag.
    See also item.hbs & site-controller
  ###
  #$(window).on 'resize' : ->
  #  $("#page-container .items .item .imgContainer canvas").each ->
  #    canvasHelper.resizeCanvasToContainer $(this)
