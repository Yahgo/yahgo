Controller = require 'controllers/base/controller'
SiteView = require 'views/site-view'
HeaderView = require 'views/header-view'
NavView = require 'views/nav-view'
PreloaderView = require 'views/preloader-view'
ErrorNotifierView = require 'views/errorNotifier-view'
ItemsView = require 'views/items-view'
ItemsCollection = require 'models/items-collection'
HistoryCollection = require 'models/items-collection'
Topics = require 'config/topics'

module.exports = class SiteController extends Controller

  initialize: ->
    super
    # Subscribe to change title event
    Chaplin.mediator.subscribe 'changeTitle', @adjustTitle

  beforeAction: (params, route) ->
    @route = route
    # Get current category
    # TODO: get localization
    topics = Topics.countries[Topics.defaultCountry]

    # Set all composers
    @reuse 'site', SiteView
    @reuse 'preloader', PreloaderView
    @reuse 'header', HeaderView
    @reuse 'nav', NavView, topics: topics
    @reuse 'customHistory', ->
      @item = new HistoryCollection null

    itemsCollection = @reuse 'items', ->
      @item = new ItemsCollection null

    @reuse 'itemsView', ->
      new ItemsView collection: itemsCollection


  # Call news fetch and handles success and error xhr calls
  showSection : (params) ->
    that = @

    preloader = @reuse 'preloader'
    customHistory = @reuse 'customHistory'
    console.log 'customHistory init'
    console.log customHistory
    itemsCollection = @reuse 'items'
    response = itemsCollection.fetch(params)

    @togglePreloader(true, preloader)

    # Context is lost in promises, we must pass composer in args (1)
    response.done (data) ->
      # (1) Composer in args
      that.togglePreloader(false, preloader)
      # We'll get a 200 response even if items are null
      if data.query.results is null
        console.log 'customHistory'
        console.log customHistory
        that.reuse 'errorNotifierView', ErrorNotifierView, {message: "empty", route: that.route, customHistory: customHistory}
      else
        # section has items, we try to push it in valid customHistory
        # (1) Composer in args
        that.checkSameLastHistory that.route, customHistory
        # Publish event
        Chaplin.mediator.publish 'updateMenus', that.route.path

    response.fail ->
      that.reuse 'errorNotifierView', ErrorNotifierView, {message: "fail", route: that.route, customHistory: customHistory}
      # (1) Composer in args
      that.togglePreloader(false, preloader)

    return



  # Will push last customHistory entry only if it's not the same as entry -2
  # or if there's no entry for now
  checkSameLastHistory : (route, customHistory) ->
    historyLength = customHistory.length
    lastEntry = customHistory.at(historyLength - 1)
    if((lastEntry is undefined) or (route.path isnt lastEntry.get "path")) then customHistory.push route


  forceReload : (params) ->
    if params.route is undefined then params.route = ""
    Chaplin.utils.redirectTo {url:params.route}, {replace: true}


  togglePreloader: (show, preloader) ->
    # Preloader can't stay in front (prevent access to news links)
    # then we have to toggle a class to hide or show him for proper transition effect
    if show
      preloader.$el.addClass "showMe"
    else
      setTimeout ->
        preloader.$el.removeClass "showMe"
      ,500

    # Fix bug with transition on freshly inserted dom elements
    setTimeout ->
      preloader.$el.toggleClass "loading"
    ,1
