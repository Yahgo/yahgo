# YQL fetcher

class YqlFetcher

  # Combine news
  #   params
  #     services : array of services that needs to be fetched by YQL
  #     country
  #     category
  #     gTopic
  makeSelect : (params) ->

    path = ""
    i = 0
    for service in params.services
      # Calling dynamically service methods
      url = @[service.name] params

      # If current service doesn't return a path (its method must returns false), we don't add it to the yql query
      if(url isnt false)
        # First operator must be "where"
        yqlOperator = if i is 0 then "where" else "or"
        path += yqlOperator + " url='" + url + "' "
        i++
    path



  # Create Yahoo rss url
  #   params
  #    country
  #    category
  yahoo : (params) ->

    path = "http://"
    # Yahoo removed "us" prefix for usa, so we must test country
    path += if (params.country is undefined) or (params.country is "us") then "" else params.country + "."
    path += "news.yahoo.com/"
    path += if (params.category is undefined) or (params.category is "") then "" else params.category + "/"
    path += "?format=rss"



  # Create Google rss url
  #   params
  #    country
  #    gTopic
  google : (params) ->

    # We retrieve google news only if gTopic exists (when a category is required)
    if (params.category isnt undefined and params.gTopic isnt undefined)
      path = "https://"
      path += "news.google.com/news/section?"
      path += "output=rss"
      path += if params.country is undefined then "" else "&ned=" + params.country
      path += if params.gTopic is undefined then "" else "&topic=" + params.gTopic
    else
      path = false



  # Prepare news URL
  #   services : array of services like yahoo, google, etc…
  #    Each service must have an associated method that prepare its RSS url
  newsURL : (params) ->
      # oAuth not used for now. We must find a decent library…
      # oAuth allow us to increase calls limit
      #oAuthKey = "dj0yJmk9b05IZFpNeU5lMGFHJmQ9WVdrOU9VNXVXbUZ5TkhFbWNHbzlPRFF5TkRjNE5EWXkmcz1jb25zdW1lcnNlY3JldCZ4PWRj"

      # See http://developer.yahoo.com/yql/guide/sorting.html for more options
      sortingOptions = "| unique(field='link') | sort(field='pubDate') | reverse()"

      query =
        #oauth_version : "1.0"
        #oauth_consumer_key : oAuthKey
        q : "select * from rss " + @makeSelect(params) + sortingOptions
        format : "json"

      requestParams =
        url : "http://query.yahooapis.com/v1/public/yql"
        data : query
        method : "GET"

# Prevent creating new properties and stuff.
Object.seal? YqlFetcher

module.exports = new YqlFetcher