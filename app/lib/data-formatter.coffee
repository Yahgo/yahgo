class DataFormatter

  mainFormatter: (items) ->

    for item in items

      # Yahoo now encapsulates image in a content key,
      # but type can be something else than an image
      imageTypePattern = /image/
      if item.content isnt undefined and
      item.content.type isnt undefined and
      imageTypePattern.test item.content.type
        item.image = item.content

      # We now look for a specific string in guid key
      googleTagPattern = /tag:news.google.com/
      if item.guid isnt undefined and
      googleTagPattern.test item.guid.content
        item = @parseGoogleNews item

      # Not Google one ? Let's parse Yahoo item
      else
        item = @parseYahooNews item

      # We don't show description when an image is displayed
      if item.image is undefined and item.description
        item.shortDescription =
          if item.shortDescription isnt undefined
          then @shortenText item.shortDescription
          else @shortenText item.description

    items



  # In Goole news, we must parse HTML descrption field
  # to extract article link, source & image
  parseGoogleNews: (item) ->
    description = item.description
    descriptionPattern = /<font size="-1"(?:[^<])*>((?:[^<])+)/
    link = item.link
    sourcePattern = /<font size="-2">([^<]+)/
    imgPattern = /<img.*src=["']([^"']+)["']/
    sourceUrlPattern = /url=(.+)/
    domainPattern = /^((?:http|https):\/\/[^\/]+)/
    item.source = {}

    # Check if we can find a source
    if sourcePattern.test description
      item.source.content = RegExp.$1

    ### Short description ###
    # Check if we can find a description text to make a short one (only if no image found)
    if item.image is undefined and descriptionPattern.test(description) is true
      item.shortDescription = RegExp.$1


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

        # If we didn't find any source name, we take domain name
        if item.source.content is undefined
          # We remove prefix
          prefixPattern = /(http|https):\/\/(w{3})?/
          item.source.content = item.source.url.replace prefixPattern, ""

    # Return formatted item
    item



  # Yahoo item parsing
  parseYahooNews: (item) ->
    description = item.description

    # Check if we can find an image
    # when no image key found
    imgPattern = /<img.*src=["']([^"']+)["']/
    if item.image is undefined and imgPattern.test(description)
      item.image =
        url : RegExp.$1

    ### Short description ###
    descriptionPattern = /<(?:.+)>([^<]+)/
    # See if we have to remove html tags (necessary only if no image found)
    if item.image is undefined and descriptionPattern.test(description)
      item.shortDescription = RegExp.$1

    # Get yahoo larger image
    unless item.image is undefined
        currentURL = item.image.url
        # We capture the second http sequence
        pattern = /.+((?:http|https):(?:\/{2}).+)/
        testURL = pattern.test currentURL
        if testURL
          item.image.url = RegExp.$1
          item.image.largeSize = true
        else
          currentURL

    # Return formatted item
    item


  shortenText: (text) ->
    cut = text.indexOf ' ', 1200
    if cut is -1
      return text
    text.substring 0, cut

# Prevent creating new properties and stuff.
Object.seal? DataFormatter
module.exports =  new DataFormatter