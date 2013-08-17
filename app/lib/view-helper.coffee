# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------

# Map helpers
# -----------

# Make 'with' behave a little more mustachey.
Handlebars.registerHelper 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)

# Inverse for 'with'.
Handlebars.registerHelper 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)

# Get Chaplin-declared named routes. {{#url "like" "105"}}{{/url}}
Handlebars.registerHelper 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params

# Parse date to fullDate format
Handlebars.registerHelper 'fullDate', (date) ->
  newDate = moment(date).format("DD/MM/YYYY HH:mm");
# Parse date to regular format
Handlebars.registerHelper 'date', (date) ->
  newDate = moment(date).format("DD/MM/YYYY");
# Parse date to smaller format
Handlebars.registerHelper 'smallDate', (date) ->
  newDate = moment(date).format("DD/MM");
# Parse date to time format
Handlebars.registerHelper 'time', (date) ->
  newDate = moment(date).format("HH:mm");
  

