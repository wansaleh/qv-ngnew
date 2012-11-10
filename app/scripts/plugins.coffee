define ['jquery', 'lodash', 'utils'],
($, _, utils) ->
  # jQuery small plugins

  $window = $(window)

  $.fn.scrollTo = (options = {}) ->
    options = _.defaults options, { duration: 1000, callback: $.noop, offset: 0 }
    $(this).each ->
      $('body').stop().animate
        scrollTop: $(this).offset().top + options.offset,
        options.duration,
        options.callback.bind this
      this

  # screen positioning
  # borrowed from https://github.com/tuupola/jquery_lazyload/blob/master/jquery.lazyload.js
  $.belowthefold = (element, settings) ->
    fold = undefined
    if settings.container is `undefined` or settings.container is window
      fold = $window.height() + $window.scrollTop()
    else
      fold = $(settings.container).offset().top + $(settings.container).height()
    fold <= $(element).offset().top - settings.threshold

  $.rightoffold = (element, settings) ->
    fold = undefined
    if settings.container is `undefined` or settings.container is window
      fold = $window.width() + $window.scrollLeft()
    else
      fold = $(settings.container).offset().left + $(settings.container).width()
    fold <= $(element).offset().left - settings.threshold

  $.abovethetop = (element, settings) ->
    fold = undefined
    if settings.container is `undefined` or settings.container is window
      fold = $window.scrollTop()
    else
      fold = $(settings.container).offset().top
    fold >= $(element).offset().top + settings.threshold + $(element).height()

  $.leftofbegin = (element, settings) ->
    fold = undefined
    if settings.container is `undefined` or settings.container is window
      fold = $window.scrollLeft()
    else
      fold = $(settings.container).offset().left
    fold >= $(element).offset().left + settings.threshold + $(element).width()

  $.inviewport = (element, settings) ->
    not $.rightoffold(element, settings) and not $.leftofbegin(element, settings) and not $.belowthefold(element, settings) and not $.abovethetop(element, settings)
