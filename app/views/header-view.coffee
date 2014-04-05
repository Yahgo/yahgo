View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  region: 'header'
  template: template

  initialize:->
  	super
  	@delegate 'focusin', 'input', @toggleNavigation
  	@delegate 'focusout', 'input', @toggleNavigation
  	@delegate 'keypress', 'input', @goSearch


  toggleNavigation: ->
  	$('#nav-container').toggleClass 'hideMe'

  goSearch: (e) ->
  	if e.keyCode is 13
  		currentValue = encodeURIComponent e.currentTarget.value
  		console.log currentValue
  		Chaplin.utils.redirectTo url: 'search/'+currentValue