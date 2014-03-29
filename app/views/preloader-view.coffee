View = require 'views/base/view'
template = require 'views/templates/preloader'

module.exports = class PreloaderView extends View
  autoRender: true
  className: 'preloader'
  region: 'preloader'
  template: template