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
    #@getYahooLargeImage(@itemsView.collection)

  showSection : (params) ->
    @items.fetch(params).then @itemsView
    
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
  
  
  # Put large images in a sized canvas for better perf
  optimizeImages : ->
    console.log(@items)
