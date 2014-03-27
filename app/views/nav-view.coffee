View = require 'views/base/view'
template = require 'views/templates/nav'

module.exports = class NavView extends View
  autoRender: true
  className: 'nav'
  region: 'nav'
  template: template


  initialize: (options) ->
    #BB doesn't get back options anymore in view
    @options = options

    #events
    @delegate 'click', '#topics li', @setActiveSection


  getTemplateData: ->
    @options.topics


  setActiveSection: (e) ->
  	console.log e
  	console.log @$el
  	#Remove all 'active' states
  	@$el.find("#topics li").removeClass 'active'
  	#'active' states on current li
  	currentMenu = $(e.currentTarget)
  	currentMenu.addClass 'active'
  	newTitle = currentMenu.find('a').html()
  	# Set Page title
  	Chaplin.mediator.publish 'adjustTitle', newTitle


