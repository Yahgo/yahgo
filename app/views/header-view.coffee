View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
	autoRender: true
	className: 'header'
	region: 'header'
	template: template

	initialize: (options) ->
		super
		#Attach options to view
		@options = options

		#Events binding
		@delegate 'focusin', 'input', @toggleNavigation
		@delegate 'focusout', 'input', @toggleNavigation
		@delegate 'keypress', 'input', @goSearch
		@delegate 'click', '#searchInfo .quitSearch', @quitSearch

	attach: ->
		super
		# Just after the container is attached to the view,
		# we can test if the route matches a search
		if @routeHasSearch() isnt null then @container.addClass 'searchActive'


	getTemplateData: ->
		templateData = {}
		templateData.search = @routeHasSearch()
		templateData

	toggleNavigation: ->
		@container.toggleClass 'searchFocus'

	goSearch: (e) ->
		if e.keyCode is 13
			currentValue = encodeURIComponent e.currentTarget.value
			Chaplin.utils.redirectTo url: 'search/'+currentValue
			Chaplin.mediator.publish 'changeTitle', decodeURIComponent currentValue

			@container
			.addClass('searchActive')
			.removeClass('searchFocus')



	quitSearch: ->
		@container.removeClass 'searchActive'

		# Look for last route that is not a search
		lastRegularRoutes =
		_.reject @options.customHistory.models, (routeModel) ->
			searchPattern = /^search\//
			return searchPattern.test routeModel.attributes.path

		if lastRegularRoutes.length > 0
			lastRoutePath = lastRegularRoutes.pop()
			routePath = lastRoutePath.attributes.path
		else
			# fallback to home if no route found
			routePath = '/'

		Chaplin.utils.redirectTo url: routePath


	#Look for possible query search
	routeHasSearch: ->
		searchPattern = /^search\/(.+)/
		query = null
		if searchPattern.test @options.route.path
			query = decodeURIComponent RegExp.$1
		query