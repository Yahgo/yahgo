module.exports = (match) ->
  match '', 'site#index'
  match ':section', 'site#showSection'