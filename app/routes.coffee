module.exports = (match) ->
  match 'forceReload', 'site#forceReload'
  match 'forceReload/:route', 'site#forceReload'
  match '', 'site#showSection'
  match ':section', 'site#showSection'