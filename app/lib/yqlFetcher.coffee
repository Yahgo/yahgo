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
        path += yqlOperator + " url='" + url
        # Check if any params have already been set
        pattern = /\?+/
        operator = if pattern.test(path) then "&" else "?"
        # Query key is `p` for yahoo and `q` for google
        queryKey = if service.name is 'yahoo' then 'p' else 'q'
        # Append query if exists
        path += if params.query then operator + queryKey + "=" + params.query else ''
        path += "' "
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
    path += if params.query then "news.search.yahoo.com/" else "news.yahoo.com"
    path += if !params.category then "" else "/" + params.category + "/"
    path += if params.query then "news/rss" else "?format=rss"



  # Create Google rss url
  #   params
  #    country
  #    gTopic
  google : (params) ->
      path = "https://"

      # We won't fetch google if we can't find a topic for category
      if params.category isnt "" && params.gTopic is undefined
        return false
      # Else we can build the url
      else if params.query or params.gTopic is undefined
        path += "news.google.com/"
      else
        path += "news.google.com/news/section"

      path += "?output=rss"
      path += if params.country is undefined then "" else "&ned=" + params.country
      path += if params.gTopic is undefined then "" else "&topic=" + params.gTopic




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