Collection = require 'models/base/collection'
ItemModel = require 'models/item'
PipesID = require 'config/pipes'

module.exports = class ItemsCollection extends Collection
  model: ItemModel
  fetch: (params) ->
    collection = @
    pipeURL = "http://pipes.yahoo.com/pipes/pipe.run"
    pipeID = PipesID[Math.floor (Math.random() * 10)]

    data =
      category: (if (params && params.section) is undefined then '' else params.section)
      country : (if (params && params.country) is undefined then 'fr' else params.section)
      _id: pipeID
      _render: "json"

    xhrOptions =
      url : pipeURL
      type : 'GET'
      data: data
      
    request = $.ajax(xhrOptions)
    .done (response) ->
      ###
      Yahoo provide a string with two urls.
      The first one is the yahoo sized image, and the second one is the original image
      
      TODO : Choisir un moyen d'afficher soit la petite ou la grande version de l'image
      Soit on affiche la petite puis on vérifie la taille du container pour ensuite décider de prendre la grande
      Soit on se base sur le window height et width pour décider sur le device aura besoin d'une iamge plus grande que celle fournie par yahoo
      Pour l'instant on affiche la grande…
      ###
      items = response.value.items
      for item in items
        # image is not necessary present
        unless item.image is undefined
          currentURL = item.image.url
          # We capture the second http sequence
          pattern = /.+(http:\/\/.+)/
          testURL = pattern.test(currentURL)
          item.image.url = if testURL then RegExp.$1 else currentURL
      
      # Populate the collection
      collection.reset items
    
    .fail ->
      errorObject =
        error: true
      collection.reset errorObject
