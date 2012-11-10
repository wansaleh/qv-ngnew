define [
  'jquery'
  'lodash'
  'underscore.string'
  'libs/backbone'
],

($, _, _str, Backbone) ->

  # Shortcut for console.log
  window.log = -> console.log.apply(console, arguments)

  # monkey patcher
  patch = (obj, fnName, callback) ->
    _old = obj[fnName]
    obj[fnName] = -> callback _old, this, arguments

  utils =
    # ruby's Array.sample :P
    sample: (array) ->
      if _.isArray array then _.first(_.shuffle(array)) else array

    # force obj to integer
    int: (obj, base = 10) ->
      if _.isString obj
        number = obj.match /\d+/g
        parseInt (if number? then number.join('') else null), base
      else if _.isNumber obj
        parseInt obj, base

    # force obj to string
    str: (obj) ->
      (new String obj).toString()

  # Extend underscore.
  _.mixin _.extend(_str, utils)

  # patch _.each, to include _.words
  patch _, 'each', (old, self, args) ->
    args = Array::slice.call(args)
    obj = args.shift()
    obj = _.words obj if _.isString obj
    old.apply self, [obj].concat(args)

  # patch Backbone.Collection to include whereFirst
  Backbone.Collection::whereFirst = do ->
    where = Backbone.Collection::where
    -> _.first where.apply this, arguments

  # jQuery small plugins
  $.fn.scrollTo = (options = {}) ->
    options = _.defaults options, { duration: 1000, callback: $.noop, offset: 0 }
    $(this).each ->
      $('body').stop().animate
        scrollTop: $(this).offset().top + options.offset,
        options.duration,
        options.callback.bind this
      this

  do ->
    # Expose underscore methods to native array
    # _ methods that we want to implement on Array.
    methods = ['each', 'map', 'reduce', 'reduceRight', 'detect', 'select',
      'reject', 'all', 'any', 'include', 'invoke', 'pluck', 'max', 'min', 'sortBy',
      'sortedIndex', 'toArray', 'size', 'first', 'rest', 'last', 'without',
      'indexOf', 'lastIndexOf', 'isEmpty', 'where', 'sample']

    # Mix in each method as a proxy.
    _.each methods, (method) ->
      Array::[method] = ->
        _[method].apply(_, [this].concat(_.toArray(arguments)))

  utils