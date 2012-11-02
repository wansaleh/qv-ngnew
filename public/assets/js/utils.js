(function() {

  define(['jquery', 'lodash', 'underscore.string'], function($, _, _str) {
    var utils;
    utils = {
      sample: function(array) {
        if (_.isArray(array)) {
          return _.first(_.shuffle(array));
        } else {
          return array;
        }
      },
      to_i: function(obj, base) {
        var number;
        if (_.isString(obj)) {
          number = obj.match(/\d+/g);
          return parseInt((number != null ? number.join('') : null), base);
        } else if (_.isNumber(obj)) {
          return parseInt(obj, base);
        }
      },
      to_s: function(obj) {
        return (new String(obj)).toString();
      }
    };
    _.mixin(_str);
    _.mixin(utils);
    _.each = (function() {
      var each;
      each = _.each;
      return function() {
        var args, obj;
        args = Array.prototype.slice.call(arguments);
        obj = args.shift();
        if (_.isString(obj)) {
          obj = _.words(obj);
        }
        return each.apply(_, [obj].concat(args));
      };
    })();
    $.fn.scrollTo = function(options) {
      if (options == null) {
        options = {};
      }
      options = _.defaults(options, {
        duration: 1000,
        callback: $.noop,
        offset: 0
      });
      $('body').animate({
        scrollTop: $(this).offset().top + options.offset
      }, options.duration, options.callback.bind(this));
      return this;
    };
    this.log = function() {
      return console.log.apply(console, arguments);
    };
    (function() {
      var methods;
      methods = ['each', 'map', 'reduce', 'reduceRight', 'detect', 'select', 'reject', 'all', 'any', 'include', 'invoke', 'pluck', 'max', 'min', 'sortBy', 'sortedIndex', 'toArray', 'size', 'first', 'rest', 'last', 'without', 'indexOf', 'lastIndexOf', 'isEmpty', 'where'];
      methods = methods.concat('sample');
      return _.each(methods, function(method) {
        return Array.prototype[method] = function() {
          return _[method].apply(_, [this].concat(_.toArray(arguments)));
        };
      });
    })();
    return utils;
  });

}).call(this);
