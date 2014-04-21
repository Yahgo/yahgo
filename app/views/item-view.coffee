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
			callback data

		request.fail ->
			callback null