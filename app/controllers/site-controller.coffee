Controller = require 'controllers/base/controller'
SiteView = require 'views/site-view'
HeaderView = require 'views/header-view'
ItemsView = require 'views/items-view'
ItemsCollection = require 'models/items-collection'
Topics = require 'config/topics'

module.exports = class SiteController extends Controller

  beforeAction: ->
    topics = Topics.countries[Topics.defaultCountry]
    @compose 'site', SiteView
    @compose 'header', HeaderView, region: 'header', topics: topics
    if @items is undefined
      @items = new ItemsCollection null
      @itemsView = new ItemsView collection: @items


  index: ->
    @items.fetch().then @itemsView
    

  showSection : (params) ->
    @items.fetch(params).then @itemsView