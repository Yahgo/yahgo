
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


  windowEvents :

    initListeners : ->
      el = window
      el.addEventListener "scroll", @checkScrollPos, false
      #el.addEventListener "resize", @resizeAllCanvas, false


    checkScrollPos : ->
      header = $("header")
      if $(window).scrollTop() > header.height()
        header.addClass "scrolled"
      else
        header.removeClass "scrolled"

    resizeAllCanvas : ->
      $("#page-container .items .item .imgContainer canvas").each ->
        canvasHelper.resizeCanvasToContainer $(this)

module.exports = canvasHelper
