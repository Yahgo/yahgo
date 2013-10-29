Controller = require 'controllers/base/controller'
SiteView = require 'views/site-view'
HeaderView = require 'views/header-view'
ItemsView = require 'views/items-view'
ItemsCollection = require 'models/items-collection'
Topics = require 'config/topics'
canvasHelper = require 'lib/canvas-helper'

module.exports = class SiteController extends Controller

  beforeAction: ->
    topics = Topics.countries[Topics.defaultCountry]
    @compose 'site', SiteView
    @compose 'header', HeaderView#, topics: topics
    
    if @items is undefined
      @items = new ItemsCollection null
      @itemsView = new ItemsView collection: @items


  index: ->
    @items.fetch().then =>
      @itemsView
      
      # Fill canvas.
      ###
      Test for canvas resizing. Comment lines below if want to revert to img tag.
        See also item.hbs & initialize
      ###
      #@fillCanvas @itemsView.collection.models

  showSection : (params) ->
    @items.fetch(params).then @itemsView
  
  fillCanvas : (items) ->

    for item, i in items
      imageObject = item.attributes.image
      unless imageObject is undefined
        imgURL = encodeURIComponent imageObject.url
        do (imgURL, i) =>
          @requestEncode64 imgURL, (data) ->
            canvas = $("#page-container .items .item").eq(i).find(".imgContainer canvas")
            canvasHelper.resizeCanvasToContainer canvas, data
  
  requestEncode64 : (url, callback) ->
    requestParams =
      url : "/encode64/"+url
    request = $.ajax requestParams
    request.done (data) ->
      #console.log "success loading image "+url
      callback data
    request.fail ->
      #console.log "failed loading image "+url
  
  
  ###
  Yahoo provide a string with two urls.
  The first one is the yahoo sized image, and the second one is the original image
    
  TODO : Choisir un moyen d'afficher soit la petite ou la grande version de l'image
  Soit on affiche la petite puis on vérifie la taille du container pour ensuite décider de prendre la grande
  Soit on se base sur le window height et width pour décider si le device aura besoin d'une image plus grande que celle fournie par yahoo
  À voir aussi du côté de canvas pour affichage/resize de la grande image
  ####
  getYahooLargeImage: (items) ->
    for item in items
      unless item.image is undefined
        currentURL = item.image.url
        # We capture the second http sequence
        pattern = /.+(http:\/\/.+)/
        testURL = pattern.test(currentURL)
        item.image.url = if testURL then RegExp.$1 else currentURL
