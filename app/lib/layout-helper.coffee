
layoutHelper =

  # Takes a canvas element, and fill it with image data
  resizeCanvasToContainer : (canvasElem, data, callback) ->

    unless data
      return

    containerWidth  = canvasElem.parent().width()
    containerHeight  = canvasElem.parent().height()
    canvasElem[0].width = containerWidth
    canvasElem[0].height = containerHeight

    ctx = canvasElem[0].getContext '2d'
    img = new Image
    img.src = data

    img.onload = ->
      #get image size
      imgWidth = img.width
      imgHeight = img.height

      cRatio = containerWidth / containerHeight
      iRatio = imgWidth / imgHeight

      # Comparing ratios
      if cRatio > iRatio
        newWidth = containerWidth
        newHeight = (containerWidth / imgWidth) * imgHeight

      else if cRatio < iRatio
        newHeight = containerHeight
        newWidth = (containerHeight / imgHeight) * imgWidth
      else
        newHeight = containerHeight
        newWidth = containerWidth

      #draw
      ctx.drawImage img, 0, 0, newWidth, newHeight
      if callback then callback()



  windowEvents :

    lastScrollTop: 0
    initListeners : ->
      el = window

      el.addEventListener "scroll", =>
        @checkScrollPos @
      ,false

      el.addEventListener "resize", ->
        #Throttle resize event
        timer = setTimeout ->
          clearTimeout(timer)
          #Publish event
          Chaplin.mediator.publish 'windowResize'
          ,250
      ,false


    checkScrollPos : (_this) ->
      header = $("header")
      scrollTop = $(window).scrollTop()

      if scrollTop >= _this.lastScrollTop
        header.removeClass "showMe"
      else
        header.addClass "showMe"

      # Maybe some enhancements needed… The transition when scrollTop is close to header height could be smoothier.
      if scrollTop > header.height()
        header.addClass "scrolled"
      else
        header.removeClass "scrolled"

      _this.lastScrollTop = scrollTop



# Prevent creating new properties and stuff.
Object.seal? layoutHelper
module.exports = layoutHelper
