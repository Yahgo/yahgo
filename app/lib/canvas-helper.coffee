
canvasHelper =

  # Takes a canvas element, and fill it with image data 
  resizeCanvasToContainer : (canvasElem, data) ->
    
    containerWidth  = canvasElem.parent().width()
    containerHeight  = canvasElem.parent().height()
    console.log containerWidth, containerHeight
    if data is undefined
      # No data provided, we have to extract data from canvas 
      data = canvasElem[0].toDataURL()

    ctx = canvasElem[0].getContext '2d'
    img = new Image
    img.src = data
    img.onload = ->
      # redraw
      ctx.drawImage img, 0, 0, containerWidth, containerHeight

module.exports = canvasHelper
