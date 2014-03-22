express = require 'express'
request = require 'request'
app = express()

app.use(express.static __dirname+'/public')

exports.startServer = (port, path, callback) ->

  # Request image and convert it to base64
  app.get '/encode64/:imgURL', (req, res) ->

    if req.params.imgURL

      # Original URL has been encoded, we must decode it
      imgURL = unescape req.params.imgURL
      pattern = /^(\/\/)/
      if pattern.test imgURL
        imgURL += req.protocol + ':' + imgURL

      # Get the distant image
      requestParams =
        uri: imgURL
        encoding: 'binary'
        method: "GET"
        timeout: 10000
        followRedirect: true
        maxRedirects: 10
      request requestParams, (error, response, body) ->

        imageObject =
          imageData: null

        if not error and response.statusCode is 200
          # Image won't be usable if not prefixed by its type and encoding method name
          dataUriPrefix = "data:" + response.headers["content-type"] + ";base64,"
          image = new Buffer(body.toString(), "binary").toString("base64")
          image = dataUriPrefix + image

          # We send back encoded image
          imageObject.imageData = image

        res.send imageObject


  # Take any other route and serve it
  app.get '*', (req, res) ->
    res.sendfile './public/index.html'

  app.listen port
  console.log 'Express server started on port '+port