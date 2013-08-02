express = require 'express'
app = express()

app.use(express.static __dirname+'/public')

exports.startServer = (port, path, callback) ->
  app.listen port
  console.log 'Express server started on port '+port