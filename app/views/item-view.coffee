View = require 'views/base/view'
template = require 'views/templates/item'

module.exports = class ItemView extends View
  autoRender: true
  className: 'item'
  template: template

  initialize: ->
  	@listenTo @, 'addedToDom', @testMethod
  	super

  testMethod: ->
  	console.log @container.html()
