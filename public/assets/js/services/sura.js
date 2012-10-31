
/*global define
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'libs/angular', 'libs/backbone', 'services/services', 'services/message', 'services/quran', 'libs/angular-resource'], function(_, angular, Backbone, services) {
    'use strict';
    return services.factory('sura', [
      '$http', '$resource', 'message', 'quran', function($http, $resource, message, quran) {
        var Ayas, activity, ayaInfo, ayas, fetch, reset;
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
          collection: new Ayas
        };
        ayas.collection.on('reset', function(res) {
          return ayas.result = res.toJSON();
        });
        ayas.collection.on('add', function(res) {
          return ayas.result.push(res.toJSON());
        });
        activity = $resource('/api/ayas.json');
        ayaInfo = function(ayas) {
          var aya, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = ayas.length; _i < _len; _i++) {
            aya = ayas[_i];
            _results.push(_.extend(aya, {
              juz: (function() {
                var juz;
                juz = _.first(quran.juzs.where({
                  sura: aya.sura_id,
                  aya: aya.aya
                }));
                if (juz != null) {
                  return juz.id;
                } else {
                  return false;
                }
              })(),
              hizb: (function() {
                var hizb;
                hizb = _.first(quran.hizbs.where({
                  sura: aya.sura_id,
                  aya: aya.aya
                }));
                if (hizb != null) {
                  return hizb.id;
                } else {
                  return false;
                }
              })(),
              ruku: (function() {
                var ruku;
                ruku = _.first(quran.rukus.where({
                  sura: aya.sura_id,
                  aya: aya.aya
                }));
                if (ruku != null) {
                  return ruku.id;
                } else {
                  return false;
                }
              })(),
              manzil: (function() {
                var manzil;
                manzil = _.first(quran.manzils.where({
                  sura: aya.sura_id,
                  aya: aya.aya
                }));
                if (manzil != null) {
                  return manzil.id;
                } else {
                  return false;
                }
              })(),
              sajda: (function() {
                var sajda;
                sajda = _.first(quran.sajdas.where({
                  sura: aya.sura_id,
                  aya: aya.aya
                }));
                if (!sajda) {
                  return 0;
                } else {
                  switch (sajda.get('hukm')) {
                    case 'recommended':
                      return 1;
                    case 'obligatory':
                      return 2;
                  }
                }
              })()
            }));
          }
          return _results;
        };
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
              ayas.collection.add(ayaInfo(resource));
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
