define ['jquery', 'lodash', 'underscore.string', 'libs/backbone'],
($, _, _str, Backbone) ->

  utils =
    # ruby's Array.sample :P
    sample: (array) ->
      if _.isArray array then _.first(_.shuffle(array)) else array

    # force obj to integer
    to_i: (obj, base) ->
      if _.isString obj
        number = obj.match /\d+/g
        parseInt (if number? then number.join('') else null), base
      else if _.isNumber obj
        parseInt obj, base

    # force obj to string
    to_s: (obj) ->
      (new String obj).toString()

  # Extend with underscore.string.
  _.mixin _str

  # Extend underscore.
  _.mixin utils

  # patch _.each, to include _.words
  _.each = do ->
    each = _.each

    ->
      args = Array::slice.call(arguments)
      obj = args.shift()
      obj = _.words obj if _.isString obj
      each.apply _, [obj].concat(args)

  # patch Backbone.Collection to include whereFirst
  Backbone.Collection::whereFirst = do ->
    where = Backbone.Collection::where

    ->
      _.first where.apply this, arguments

  # jQuery small plugins
  $.fn.scrollTo = (options = {}) ->
    options = _.defaults options, { duration: 1000, callback: $.noop, offset: 0 }
    $(this).each ->
      $('body').animate
        scrollTop: $(this).offset().top + options.offset,
        options.duration,
        options.callback.bind this
      this

  # Shortcut for console.log
  @log = ->
    console.log.apply(console, arguments)

  do ->
    # Expose underscore methods to native array
    # _ methods that we want to implement on Array.
    methods = ['each', 'map', 'reduce', 'reduceRight', 'detect', 'select',
      'reject', 'all', 'any', 'include', 'invoke', 'pluck', 'max', 'min', 'sortBy',
      'sortedIndex', 'toArray', 'size', 'first', 'rest', 'last', 'without',
      'indexOf', 'lastIndexOf', 'isEmpty', 'where']

    # the one we defined before
    methods = methods.concat 'sample'

    # Mix in each method as a proxy.
    _.each methods, (method) ->
      Array::[method] = ->
        _[method].apply(_, [this].concat(_.toArray(arguments)))

  utils