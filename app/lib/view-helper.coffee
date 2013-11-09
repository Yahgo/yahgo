# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
 
registerHelper = (name, fn) ->
  Handlebars.registerHelper name, fn
 
# Map helpers
# -----------
 
# Make 'with' behave a little more mustachey.
registerHelper 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)
 
# Inverse for 'with'.
registerHelper 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)
 
# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
registerHelper 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params


# Parse date to fullDate format
registerHelper 'fullDate', (date) ->
  newDate = moment(date).format("DD/MM/YYYY HH:mm")
# Parse date to regular format
registerHelper 'date', (date) ->
  newDate = moment(date).format("DD/MM/YYYY")
# Parse date to smaller format
registerHelper 'smallDate', (date) ->
  newDate = moment(date).format("DD/MM")
# Parse date to time format
registerHelper 'time', (date) ->
  newDate = moment(date).format("HH:mm")
  


# Ugly fix for registering partials
# Still not fixed in handlebars-brunch > https://github.com/brunch/handlebars-brunch/issues/10
registerPartial = (name, fn) ->
  Handlebars.registerPartial name, fn
 
preloader = require 'views/templates/preloader'
registerPartial "preloader", preloader


