Collection = require 'models/base/collection'
Controller = require 'controllers/base/controller'
SiteView = require 'views/site-view'
HeaderView = require 'views/header-view'
NavView = require 'views/nav-view'
ErrorNotifierView = require 'views/errorNotifier-view'
ItemsView = require 'views/items-view'
ItemsCollection = require 'models/items-collection'
HistoryCollection = require 'models/items-collection'
Topics = require 'config/topics'
layoutHelper = require 'lib/layout-helper'
preloader = require 'views/templates/preloader'

module.exports = class SiteController extends Controller

  beforeAction: (params, route) ->
    topics = Topics.countries[Topics.defaultCountry]
    @reuse 'site', SiteView
    @reuse 'header', HeaderView
    @reuse 'nav', NavView, topics: topics
    @route = route

    @reuse 'history', ->
      @collection = new HistoryCollection null

    itemsCollection = @reuse 'items', ->
      # Still don't understand why the following var must be named item instead of items
      # http://ost.io/@chaplinjs/chaplin/topics/155
      @item = new ItemsCollection null

    @reuse 'itemsView', ->
      @itemsCollectionView = new ItemsView collection: itemsCollection



  # Call news fetch and handles success and error xhr calls
  showSection : (params) ->
    @togglePreloader(true)
    that = @
    history = @reuse 'history'
    itemsCollection = @reuse('items')
    response = itemsCollection.fetch(params)

    response.done (data) ->
      that.togglePreloader()
      # We'll get a 200 response even if items are null
      if data.query.results is null
        that.reuse 'errorNotifierView', ErrorNotifierView, {message: "empty", route: that.route, history: history}
      else
        # section has items, we try to push it in valid history
        # We must pass history in args, because history doesn't seem to persist
        # in checkSameLastHistory when called from promise context
        that.checkSameLastHistory that.route, history

    response.fail ->
      that.reuse 'errorNotifierView', ErrorNotifierView, {message: "fail", route: that.route, history: history}
      that.togglePreloader()

    return



  # Will push last history entry only if it's not the same as entry -2
  # or if there's no entry for now
  checkSameLastHistory : (route, history) ->
    historyLength = history.collection.length
    lastEntry = history.collection.at(historyLength - 1)
    if((lastEntry is undefined) or (route.path isnt lastEntry.get "path")) then history.collection.push route


  forceReload : (params) ->
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


  ###
  Yahoo provide a string with two urls.
  The first one is the yahoo sized image, and the second one is the original image
  ###
  getYahooLargeImage: (items) ->
    for item in items
      unless item.image is undefined
        currentURL = item.image.url
        # We capture the second http sequence
        pattern = /.+(http:\/\/.+)/
        testURL = pattern.test(currentURL)
        item.image.url = if testURL then RegExp.$1 else currentURL
