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
    sample: (array, n, guard) ->
      return array[Math.floor(Math.random() * array.length)]  if not n? or guard
      n = Math.max(0, Math.min(array.length, n))
      (pickR = (array, n, length) ->
        i = undefined
        picked = undefined
        rest = undefined
        hasIndex = undefined
        return []  if n is 0
        i = Math.floor(Math.random() * length)
        hasIndex = array.hasOwnProperty(i) # This is needed for restoration of dense arrays
        picked = array[i]
        array[i] = array[length - 1]
        rest = pickR(array, n - 1, length - 1)

        # Restore array
        if hasIndex
          array[i] = picked
        else
          delete array[i]
        rest.push picked
        rest
      ) array, n, array.length

    # setInterval wrapper
    interval: (func, wait) ->
      args = Array::slice.call(arguments, 2)
      setInterval (-> func.apply null, args), wait

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

    # force obj to boolean
    bool: (value) ->
      if value && value.length != 0
        v = ("" + value).toLowerCase()
        !(v == 'f' || v == '0' || v == 'false' || v == 'no' || v == 'n' || v == '[]')
      else
        false

  # Extend underscore.
  _.mixin _.extend(_str, utils)

  # patch _.each, to include _.words
  # underscore = _
  # patch underscore, 'each', (old, self, args) ->
  #   args = Array::slice.call(args)
  #   obj = args.shift()
  #   obj = underscore.words obj if _.isString obj
  #   old.apply self, [obj].concat(args)

  # patch Backbone.Collection to include whereFirst
  Backbone.Collection::whereFirst = do ->
    _where = Backbone.Collection::where
    -> _.first _where.apply this, arguments

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