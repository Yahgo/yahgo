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


  getTemplateData: ->
    @options.topics