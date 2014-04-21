module.exports = (match) ->
  match 'forceReload', 'site#forceReload'
  match 'forceReload/:route', 'site#forceReload'
  match 'search/:query', 'site#showItemsFromSearch'
  match '', 'site#showItems'
  match ':section', 'site#showItems'