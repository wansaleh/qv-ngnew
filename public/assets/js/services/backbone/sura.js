
/*global define
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['libs/angular', 'libs/backbone', 'services/services', 'services/message', 'services/quran', 'libs/angular-resource'], function(angular, Backbone, services) {
    'use strict';
    return services.factory('sura', [
      '$http', '$resource', 'message', 'quran', function($http, $resource, message, quran) {
        var Ayas, activity, ayas, fetch, reset;
        Ayas = (function(_super) {

          __extends(Ayas, _super);

          function Ayas() {
            return Ayas.__super__.constructor.apply(this, arguments);
          }

          Ayas.prototype.url = '/api/ayas.json';

          Ayas.prototype.comparator = function(aya) {
            return aya.get('aya');
          };

          return Ayas;

        })(Backbone.Collection);
        ayas = {
          result: [],
          ids: [],
          collection: new Ayas
        };
        ayas.collection.on('reset', function(res) {
          return ayas.result = res.toJSON();
        });
        ayas.collection.on('add', function(res) {
          return ayas.result.push(res.toJSON());
        });
        activity = $resource('/api/ayas.json');
        fetch = function(suraId, success) {
          var $doc, $win, suraInfo, _lazyloader, _offset, _query;
          if (success == null) {
            success = angular.noop;
          }
          $win = $(window);
          $doc = $(document);
          console.group('sura service:', suraId);
          $win.off('scroll', _lazyloader);
          suraInfo = quran.suras.get(suraId);
          _offset = function() {
            var last;
            if (last = ayas.collection.last()) {
              return last.get('aya');
            } else {
              return 0;
            }
          };
          _query = function() {
            console.log('start sura:', suraId, 'aya:', _offset() + 1);
            return activity.query({
              sura_id: suraId,
              offset: _offset(),
              limit: 20
            }, function(resource, headers) {
              ayas.collection.add(resource);
              $win.on('scroll', _lazyloader);
              return success();
            });
          };
          _lazyloader = _.throttle(function() {
            if ($win.scrollTop() > $doc.height() - $win.height() && _offset() < suraInfo.get('ayas')) {
              return _query();
            }
          }, 200);
          _query();
          return console.groupEnd();
        };
        reset = function() {
          ayas.result = [];
          ayas.ids = [];
          return ayas.collection.reset();
        };
        return {
          fetch: fetch,
          reset: reset,
          ayas: ayas,
          activity: activity
        };
      }
    ]);
  });

}).call(this);
