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
      collection.reset(response.value.items)
    