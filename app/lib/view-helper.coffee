# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
 
register = (name, fn) ->
  Handlebars.registerHelper name, fn
 
# Map helpers
# -----------
 
# Make 'with' behave a little more mustachey.
register 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)
 
# Inverse for 'with'.
register 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)
 
# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
register 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params


# Parse date to fullDate format
register 'fullDate', (date) ->
  newDate = moment(date).format("DD/MM/YYYY HH:mm")
# Parse date to regular format
register 'date', (date) ->
  newDate = moment(date).format("DD/MM/YYYY")
# Parse date to smaller format
register 'smallDate', (date) ->
  newDate = moment(date).format("DD/MM")
# Parse date to time format
register 'time', (date) ->
  newDate = moment(date).format("HH:mm")