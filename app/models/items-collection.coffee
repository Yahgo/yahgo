Collection = require 'models/base/collection'
ItemModel = require 'models/item'
PipesID = require 'config/pipes'

module.exports = class ItemsCollection extends Collection
  model: ItemModel
  fetch: (params) ->
    collection = @
    pipeURL = "http://pipes.yahoo.com/pipes/pipe.run"
    pipeID = PipesID[Math.floor (Math.random() * 10)]
    
    newParams =
      section : ('' if params && params.section is undefined)
      country : ('fr' if params && params.country is undefined)
    
    data =
      category: newParams.section
      country : newParams.country
      _id: pipeID
      _render: "json"
      
    xhrOptions =
      url : pipeURL
      type : 'GET'
      data: data
      
    request = $.ajax(xhrOptions)
    .done (response) ->
      collection.reset(response.value.items)
    