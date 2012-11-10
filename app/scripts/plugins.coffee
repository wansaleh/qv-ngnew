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