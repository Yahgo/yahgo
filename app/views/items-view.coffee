CollectionView = require 'views/base/collection-view'
ItemView = require 'views/item-view'

# Site view is a top-level view which is bound to body.
module.exports = class ItemsView extends CollectionView
  autoRender: true
  renderItems: true
  animationDuration: 0
  itemView: ItemView
  region: 'items'
  tagName: 'ul'