Collection = require 'models/base/collection'
ItemModel = require 'models/item'
#PipesID = require 'config/pipes'
Topics = require 'config/topics'
yqlFetcher = require 'lib/yqlFetcher'

module.exports = class ItemsCollection extends Collection
  model: ItemModel
  
  fetch : (params) ->
    collection = @
    
    # Fetcher prefs
    # TODO : we must handle l10n & i18n…  
    fetcherParams =
      services :
        [
          name: "yahoo"
        ,
          name: "google"
        ]
      category : if (params && params.section) is undefined then '' else params.section
      country : if (params && params.country) is undefined then Topics.defaultCountry else params.country
      
    # Find google topic in local Topics
    unless (params && params.section) is undefined
      countryTopics = Topics.countries[fetcherParams.country].topics
      currentTopic = _.find countryTopics, (topic) ->
        return (topic.section is fetcherParams.category && topic.gTopic isnt undefined)
      
      # For specific countries, current google topic sometimes doesn't exist
      unless currentTopic is undefined
        fetcherParams.gTopic = currentTopic.gTopic
    

    xhrOptions = yqlFetcher.newsURL fetcherParams
    request = $.ajax(xhrOptions)
    .done (response) =>
      
      items = response.query.results.item
      # We added a specific key for Google and can test if exists for each item
      for item in items
        # since we don't use pipes anymore, the key doesn't exist anymore. We now check for guid key
        unless item.guid is undefined
          item = @parseGoogleNews item
      
      # Populate the collection
      collection.reset items
    

    # Error case
    # TODO : improve error handling 
    .fail ->
      errorObject =
        error: true
    
      collection.reset errorObject

  
  
        
      
  # In Goole news, we must parse HTML descrption field to extract article link, source & image
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
      item.image =
        url : RegExp.$1
      
    # Extract correct url from Google link
    if sourceUrlPattern.test link
      item.link = RegExp.$1
      
      # Extract domain from previous parsed link
      if domainPattern.test item.link
        item.source.url = RegExp.$1

    return item
    

# OLD FETCH for pipes    
#fetch: (params) ->
#  collection = @
#  pipeURL = "http://pipes.yahoo.com/pipes/pipe.run"
#  pipeID = PipesID[Math.floor (Math.random() * 10)]
#  
#  # Check for any params provided (country & section) 
#  data =
#    category: (if (params && params.section) is undefined then '' else params.section)
#    country : (if (params && params.country) is undefined then Topics.defaultCountry else params.country
#    _id: pipeID
#    _render: "json"
#    
#    
#  # Find google topic in local Topics
#  unless (params && params.section) is undefined
#    countryTopics = Topics.countries[data.country].topics
#    currentTopic = _.find countryTopics, (topic) ->
#      return (topic.section is data.category && topic.gTopic isnt undefined)
#    
#    # For specific countries, current google topic sometimes doesn't exist
#    unless currentTopic is undefined
#      data.topic = currentTopic.gTopic
#      data.ned = data.country
#    
#  
#  
#  xhrOptions =
#    url : pipeURL
#    type : 'GET'
#    data: data
#    
#  request = $.ajax(xhrOptions)
#  .done (response) =>
#    
#    items = response.value.items
#    
#    # We added a specific key for Google and can test if exists for each item
#    for item in items
#      unless item.isGoogle is undefined
#        item = @parseGoogleNews item
#    
#    # Populate the collection
#    collection.reset items
#  
#  # Error case
#  # TODO : improve error handling 
#  .fail ->
#    errorObject =
#      error: true
#
#    collection.reset errorObject

