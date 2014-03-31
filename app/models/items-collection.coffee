Collection = require 'models/base/collection'
ItemModel = require 'models/item'
Topics = require 'config/topics'
YqlFetcher = require 'lib/yqlFetcher'
DataFormatter = require 'lib/data-formatter'
#PipesID = require 'config/pipes'

module.exports = class ItemsCollection extends Collection
  model: ItemModel

  errorObject =
        error: true

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

      # Get current category
      category : if params is null or params.section is undefined
      then '' else params.section

      # Get current country
      country : if params is null or params.country is undefined
      then Topics.defaultCountry else params.country

    # Find google topic in local Topics
    unless params is null or params.section is undefined
      countryTopics = Topics.countries[fetcherParams.country].topics
      currentTopic = _.find countryTopics, (topic) ->
        return (topic.section is fetcherParams.category && topic.gTopic isnt undefined)

      # For specific countries, current google topic sometimes doesn't exist
      unless currentTopic is undefined
        fetcherParams.gTopic = currentTopic.gTopic


    xhrOptions = YqlFetcher.newsURL fetcherParams



    # Make request
    # All failed answers (error code or empty items)
    # are handled directly in site controller
    request = $.ajax(xhrOptions)

    .done (response) =>

      results = response.query.results

      # We'll get a 200 response even if items are null
      if results isnt null

        items = DataFormatter.mainFormatter results.item

        # Populate the collection
        collection.reset items




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