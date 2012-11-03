
/*global define
*/


(function() {

  define(['libs/angular', 'libs/backbone', 'libs/store', 'services/services', 'services/message', 'services/quran', 'libs/angular-resource'], function(angular, Backbone, store, services) {
    'use strict';
    return services.factory('quranIndex', [
      '$resource', 'message', 'quran', function($resource, message, quran) {
        var Suras, activity, fetch, reset, suras;
        Suras = Backbone.Collection.extend({
          url: '/api/suras.js',
          comparator: function(sura) {
            return sura.get('id');
          }
        });
        suras = {
          result: [],
          collection: new Suras
        };
        suras.collection.on('reset', function(res) {
          return suras.result = res.toJSON();
        });
        activity = $resource('/api/suras.json');
        fetch = function(success) {
          var suras_store;
          if (success == null) {
            success = angular.noop;
          }
          if (_.isUndefined(suras_store = store.get('suras.result'))) {
            return activity.query(function(resource, headers) {
              suras.collection.reset(resource);
              store.set('suras.result', resource);
              return success();
            });
          } else {
            return suras.collection.reset(suras_store);
          }
        };
        reset = function() {
          suras.result = [];
          return suras.collection.reset();
        };
        return {
          fetch: fetch,
          reset: reset,
          suras: suras,
          activity: activity
        };
      }
    ]);
  });

}).call(this);
