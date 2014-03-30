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
		@getYahooLargeImage()
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
					if data isnt null
						# Store data in model
						@model.attributes.imgData = data
						@renderCanvas data
			else
				@renderCanvas imgData


	renderCanvas : (data) ->
		imgContainer = @$el.find ".imgContainer"
		if data isnt null && data.imageData isnt null
			canvas = imgContainer.find "canvas"
			callback = =>
				# we only pixelate low res image
				unless @model.attributes.image.largeSize
					@closePixelate canvas
			layoutHelper.resizeCanvasToContainer canvas, data.imageData, callback

		else
			imgContainer.remove()

	closePixelate: (canvas) ->
		options =
			brushes:
				[
					{ resolution: 16 },
					{ shape : 'circle', resolution : 16, offset: 7 },
					{ shape : 'circle', resolution : 16, size: 13, offset: 7 },
					{ shape : 'circle', resolution : 16, size: 10, offset: 6 },
					{ shape : 'circle', resolution : 16, size: 6, offset: 4 }
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

	###
	Yahoo provide a string with two urls.
	The first one is the yahoo sized image, and the second one is the original image
	###
	getYahooLargeImage: ->
		item = @model.attributes
		unless item.image is undefined
		    currentURL = item.image.url
		    # We capture the second http sequence
		    pattern = /.+((?:http|https):(?:\/{2}).+)/
		    testURL = pattern.test(currentURL)
		    if testURL
		    	item.image.url = RegExp.$1
		    	item.image.largeSize = true
		    else
		    	currentURL