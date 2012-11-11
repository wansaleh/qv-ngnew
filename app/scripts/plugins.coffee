define ['jquery', 'lodash', 'utils'],
($, _, utils) ->
  # jQuery small plugins

  $window = $(window)

  $.fn.scrl = (options = {}) ->
    options = _.defaults options, { duration: 1000, callback: $.noop, offset: 0 }
    $(this).each ->
      $('body').stop().animate
        scrollTop: $(this).offset().top + options.offset,
        options.duration,
        options.callback.bind this
      this

  $.expr.filters.offscreen = (el) ->
    ((el.offsetLeft + el.offsetWidth) < 0 or
     (el.offsetTop + el.offsetHeight) < 0) or
     (el.offsetLeft > window.innerWidth or
     el.offsetTop > window.innerHeight)

  $.expr.filters.onscreen = (el) ->
    not $.expr.filters.offscreen(el)

  # ========================================================================
  # hoverdir
  # ========================================================================
  $.HoverDir = (options, element) ->
    @$el = $(element)
    @_init options

  $.HoverDir.defaults =
    hoverDelay: 0
    reverse: false

  $.HoverDir:: =
    _init: (options) ->
      @options = $.extend(true, {}, $.HoverDir.defaults, options)

      # load the events
      @_loadEvents()

    _loadEvents: ->
      _self = this
      @$el.on "mouseenter.hoverdir, mouseleave.hoverdir", (event) ->
        $el = $(this)
        evType = event.type
        $hoverElem = $el.find(".secondview")
        direction = _self._getDir($el,
          x: event.pageX
          y: event.pageY
        )
        hoverClasses = _self._getClasses(direction)
        $hoverElem.attr("class", "secondview")
        if evType is "mouseenter"
          $hoverElem.hide().addClass hoverClasses.from
          clearTimeout _self.tmhover
          _self.tmhover = setTimeout(->
            $hoverElem.show 0, ->
              $(this).addClass("da-animate").addClass hoverClasses.to

          , _self.options.hoverDelay)
        else
          $hoverElem.addClass "da-animate"
          clearTimeout _self.tmhover
          $hoverElem.addClass hoverClasses.from

    # credits : http://stackoverflow.com/a/3647634
    _getDir: ($el, coordinates) ->

      ###
      the width and height of the current div *
      ###
      w = $el.width()
      h = $el.height()

      ###
      calculate the x and y to get an angle to the center of the div from that x and y. *
      ###

      ###
      gets the x value relative to the center of the DIV and "normalize" it *
      ###
      x = (coordinates.x - $el.offset().left - (w / 2)) * ((if w > h then (h / w) else 1))
      y = (coordinates.y - $el.offset().top - (h / 2)) * ((if h > w then (w / h) else 1))

      ###
      the angle and the direction from where the mouse came in/went out clockwise (TRBL=0123);*
      ###

      ###
      first calculate the angle of the point,
      add 180 deg to get rid of the negative values
      divide by 90 to get the quadrant
      add 3 and do a modulo by 4  to shift the quadrants to a proper clockwise TRBL (top/right/bottom/left) *
      ###
      direction = Math.round((((Math.atan2(y, x) * (180 / Math.PI)) + 180) / 90) + 3) % 4
      direction

    _getClasses: (direction) ->
      fromClass = undefined
      toClass = undefined
      switch direction
        when 0
          # from top
          (if (not @options.reverse) then fromClass = "da-slideFromTop" else fromClass = "da-slideFromBottom")
          toClass = "da-slideTop"
        when 1
          # from right
          (if (not @options.reverse) then fromClass = "da-slideFromRight" else fromClass = "da-slideFromLeft")
          toClass = "da-slideLeft"
        when 2
          # from bottom
          (if (not @options.reverse) then fromClass = "da-slideFromBottom" else fromClass = "da-slideFromTop")
          toClass = "da-slideTop"
        when 3
          # from left
          (if (not @options.reverse) then fromClass = "da-slideFromLeft" else fromClass = "da-slideFromRight")
          toClass = "da-slideLeft"
      from: fromClass
      to: toClass

  $.fn.hoverdir = (options) ->
    if typeof options is "string"
      args = Array::slice.call(arguments, 1)
      @each ->
        instance = $.data(this, "hoverdir")
        unless instance
          console.error "cannot call methods on hoverdir prior to initialization; " + "attempted to call method '" + options + "'"
          return
        if not $.isFunction(instance[options]) or options.charAt(0) is "_"
          console.error "no such method '" + options + "' for hoverdir instance"
          return
        instance[options].apply instance, args

    else
      @each ->
        instance = $.data(this, "hoverdir")
        $.data this, "hoverdir", new $.HoverDir(options, this)  unless instance

    this