
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
    
    lastScrollTop: 0
    initListeners : ->
      el = window
      el.addEventListener "scroll", @checkScrollPos, false
      #el.addEventListener "resize", @resizeAllCanvas, false


    checkScrollPos : ->
      header = $("header")
      scrollTop = $(window).scrollTop()
      console.log @lastScrollTop
      console.log scrollTop 
      if scrollTop >= @lastScrollTop
        console.log "scrolled up"
        header.removeClass "scrolled"
      else if scrollTop > header.height()
        console.log "scrolled down"
        header.addClass "scrolled"
      else
        console.log "scrolled up"
        header.removeClass "scrolled"

      @lastScrollTop = scrollTop

    resizeAllCanvas : ->
      $("#page-container .items .item .imgContainer canvas").each ->
        canvasHelper.resizeCanvasToContainer $(this)
        
# Prevent creating new properties and stuff.
Object.seal? canvasHelper
module.exports = canvasHelper
