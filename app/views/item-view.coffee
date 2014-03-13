View = require 'views/base/view'
template = require 'views/templates/item'
layoutHelper = require 'lib/layout-helper'

module.exports = class ItemView extends View
	autoRender: true
	className: 'item'
	template: template


	###
	While we need to know when item has been rendered,
	we have to super initialize and render methods,
	and then call our custom methods.
	###
	initialize: ->
		super

	render: ->
		super
		@resizeCanvas()


	resizeCanvas : ->

		imageObject = @model.attributes.image
		unless imageObject is undefined
			imgURL = encodeURIComponent imageObject.url
			@requestEncode64 imgURL, (data) =>
				imgContainer = @$el.find(".imgContainer")
				if data isnt null
					layoutHelper.resizeCanvasToContainer imgContainer.find("canvas"), data
				else
					imgContainer.remove()



	requestEncode64 : (url, callback) ->
		requestParams =
			url : "/encode64/"+url

		request = $.ajax requestParams
		request.done (data) ->
			#console.log "success loading image "+url
			callback data

		request.fail ->
			callback null
			#console.log "failed loading image "+url