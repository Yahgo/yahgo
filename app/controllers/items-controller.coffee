Controller = require 'controllers/base/controller'
Collection = require 'models/base/collection'
SiteView = require 'views/site-view'
HeaderView = require 'views/header-view'
ItemsView = require 'views/items-view'
ItemModel = require 'models/item'

module.exports = class ItemsController extends Controller

  beforeAction: ->
    @compose 'site', SiteView
    @compose 'header', HeaderView, region: 'header'

  index: ->
    
    @items = new Collection null, model: ItemModel
    @items.url = "http://pipes.yahoo.com/pipes/pipe.run?_id=1f92952fb05980d031395280cd612a95&_render=json&category=world&country=fr"
    @itemsView = new ItemsView collection: @items, region: 'items'
    # TODO : overrider la méthode fetch pour ne récupérér que les items du data de la réponse
    @items.fetch.then @view = new ItemsView
    