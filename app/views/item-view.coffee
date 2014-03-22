View = require 'views/base/view'
template = require 'views/templates/item'
layoutHelper = require 'lib/layout-helper'
ClosePixelation = require 'lib/close-pixelate'

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
		@getCanvasData()

	listen:
		'windowResize mediator': 'getCanvasData'


	getCanvasData : ->

		imageObject = @model.attributes.image
		imgData = @model.attributes.imgData
		unless imageObject is undefined
			if imgData is undefined
				imgURL = encodeURIComponent imageObject.url
				#Get data from request
				@requestEncode64 imgURL, (data) =>
					@renderCanvas data
			else
				@renderCanvas {imageData: imgData}


	renderCanvas : (data) ->
		imgContainer = @$el.find ".imgContainer"
		if data isnt null && data.imageData isnt null
			canvas = imgContainer.find "canvas"
			callback = =>
				@closePixelate canvas
			layoutHelper.resizeCanvasToContainer canvas, data.imageData, callback

		else
			imgContainer.remove()

	closePixelate: (canvas) ->
		options =
			brushes:
				[
					{shape: 'diamond', resolution: 12, size: 27, offset: 9},
					{shape: 'circle', resolution: 50, size: 24, offset: 0, alpha: 0.7},
					{shape: 'square', resolution: 70, size: 12, offset: 4, alpha: 0.5},
					{shape: 'circle', resolution: 10, size: 11, offset: 8, alpha: 0.4}
				]

		# Lez pixelate !
		new ClosePixelation canvas[0], options


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