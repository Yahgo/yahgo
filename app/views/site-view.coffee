View = require 'views/base/view'
template = require 'views/templates/site'

# Site view is a top-level view which is bound to body.
module.exports = class SiteView extends View
  autoRender: true
  container: 'body'
  id: 'site-container'
  regions:
    items: '#page-container'
    header: '#header-container'
  template: template
