Collection = require 'models/base/collection'
ItemModel = require 'models/item'
PipesID = require 'config/pipes'
Topics = require 'config/topics'

module.exports = class ItemsCollection extends Collection
  model: ItemModel
  fetch: (params) ->
    collection = @
    pipeURL = "http://pipes.yahoo.com/pipes/pipe.run"
    pipeID = PipesID[Math.floor (Math.random() * 10)]

    data =
      category: (if (params && params.section) is undefined then '' else params.section)
      country : (if (params && params.country) is undefined then Topics.defaultCountry else params.country)
      _id: pipeID
      _render: "json"
      
      
    # Find google topic in local Topics
    unless (params && params.section) is undefined
      countryTopics = Topics.countries[data.country].topics
      currentTopic = _.find countryTopics, (topic) ->
        return (topic.section is data.category && topic.gTopic isnt undefined)
      console.log currentTopic
      
      unless currentTopic is undefined
        data.topic = currentTopic.gTopic
        data.ned = data.country
        console.log data
      
    
    
    xhrOptions =
      url : pipeURL
      type : 'GET'
      data: data
      
    request = $.ajax(xhrOptions)
    .done (response) =>
      ###
      Yahoo provide a string with two urls.
      The first one is the yahoo sized image, and the second one is the original image
      
      #TODO : Choisir un moyen d'afficher soit la petite ou la grande version de l'image
      #Soit on affiche la petite puis on vérifie la taille du container pour ensuite décider de prendre la grande
      #Soit on se base sur le window height et width pour décider si le device aura besoin d'une image plus grande que celle fournie par yahoo
      #Pour l'instant on affiche la grande…
      ####
      items = response.value.items
      #for item in items
      #  # We added a specific key for Google and can test it
      #  unless item.isGoogle is undefined
      #    item = @parseGoogleNews item
      #
      #  # image is not necessary present
      #  unless item.image is undefined
      #    currentURL = item.image.url
      #    # We capture the second http sequence
      #    pattern = /.+(http:\/\/.+)/
      #    testURL = pattern.test(currentURL)
      #    item.image.url = if testURL then RegExp.$1 else currentURL
      
      # Populate the collection
      collection.reset items
    
    .fail ->
      errorObject =
        error: true
      collection.reset errorObject
      
      

  parseGoogleNews: (item) ->
    description = item.description
    link = item.link
    sourcePattern = /<font size="-2">([^<]+)/
    imgPattern = /<img.*src=["']([^"']+)["']/
    sourceUrlPattern = /url=(.+)/
    domainPattern = /^((?:http|https):\/\/[^\/]+)/
    item.source = {}

    # Check if we can find a source
    if sourcePattern.test description
      item.source.content = RegExp.$1
      
    # Check if we can find an image
    if imgPattern.test description
      item.image = RegExp.$1
      
    # Extract correct url from Google link
    if sourceUrlPattern.test link
      item.link = RegExp.$1
      
      # Extract domain from previous parsed link
      if domainPattern.test item.link
        item.source.url = RegExp.$1

    return item
