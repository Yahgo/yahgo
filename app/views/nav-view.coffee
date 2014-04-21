View = require 'views/base/view'
template = require 'views/templates/nav'

module.exports = class NavView extends View
  autoRender: true
  className: 'nav'
  region: 'nav'
  template: template


  initialize: (options) ->
    #Attach options to view
    @options = options
    @subscribeEvent 'updateMenus', @updateMenus



  getTemplateData: ->
    templateData =
      topics: @options.topics



  updateMenus: (path) ->
    topics = @$el.find "#topics li"
    # Remove all 'active' states
    topics.removeClass 'active'

    ### Update currentMenu ###
    # Remove `/` for home
    currentPath = if path is '' then '/' else path

    #Check if path starts with `search/`
    pattern = /^search\//
    if pattern.test(path)
      @$el.addClass 'search'
    else
      @$el.removeClass 'search'
      currentMenu = topics.find 'a[href="' + currentPath + '"]'
      currentMenu.parent().addClass 'active'
      newTitle = currentMenu.html()
    Chaplin.mediator.publish 'changeTitle', newTitle