Controller = require 'controllers/base/controller'
SiteView = require 'views/site-view'
HeaderView = require 'views/header-view'
NavView = require 'views/nav-view'
ErrorNotifierView = require 'views/errorNotifier-view'
ItemsView = require 'views/items-view'
ItemsCollection = require 'models/items-collection'
Topics = require 'config/topics'
canvasHelper = require 'lib/canvas-helper'
preloader = require 'views/templates/preloader'

module.exports = class SiteController extends Controller

  beforeAction: (params, route) ->
    topics = Topics.countries[Topics.defaultCountry]
    @reuse 'site', SiteView
    @reuse 'header', HeaderView
    @reuse 'nav', NavView, topics: topics
    @route = route

    itemsCollection = @reuse 'items', ->
      # Still don't understand why the following var must be named item instead of items
      # http://ost.io/@chaplinjs/chaplin/topics/155
      @item = new ItemsCollection null

    @reuse 'itemsView', ->
      @itemsCollectionView = new ItemsView collection: itemsCollection


    # Fill canvas.
    ###
    Test for canvas resizing. Comment lines below if want to revert to img tag.
      See also item.hbs & initialize
    ###
    #@fillCanvas @itemsView.collection.models

  showSection : (params) ->
    @togglePreloader(true)
    that = @
    response = @reuse('items').fetch(params)

    response.done (data) ->
      that.togglePreloader()
      # We'll get a 200 response even if items are null
      if data.query.results is null
        that.reuse 'errorNotifierView', ErrorNotifierView, {message: "empty", route: that.route}

    response.fail ->
      that.reuse 'errorNotifierView', ErrorNotifierView, {message: "fail", route: that.route}
      that.togglePreloader()

    return


  forceReload : (params) ->
    console.log params.route
    if params.route is undefined then params.route = ""
    Chaplin.utils.redirectTo {url:params.route}, {replace: true}


  togglePreloader: (show) ->
    # Preloader can't stay in front (prevent access to news links)
    # then we have to toggle a class to hide or show him for proper transition effect
    preloader = $("#wrapper #preloader")

    if show
      preloader.addClass "showMe"
    else
      setTimeout ->
        preloader.removeClass "showMe"
      ,500

    # Fix bug with transition on freshly inserted dom elements
    setTimeout ->
      preloader.toggleClass "loading"
    ,1




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
