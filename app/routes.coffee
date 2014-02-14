module.exports = (match) ->
  match '', 'site#showSection'
  match ':section', 'site#showSection'