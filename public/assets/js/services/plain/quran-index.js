
/*global define
*/


(function() {

  define(['libs/angular', 'libs/store', 'services/services', 'services/message', 'services/quran', 'libs/angular-resource'], function(angular, store, services) {
    'use strict';
    return services.factory('quranIndex', [
      '$resource', 'message', 'quran', function($resource, message, quran) {
        var activity, fetch, reset, suras;
        suras = {
          result: []
        };
        activity = $resource('/api/suras.json');
        fetch = function(success) {
          var suras_store;
          if (success == null) {
            success = angular.noop;
          }
          if (_.isUndefined(suras_store = store.get('suras.result'))) {
            return suras.result = activity.query(function(resource, headers) {
              store.set('suras.result', resource);
              return success();
            });
          } else {
            return suras.result = suras_store;
          }
        };
        reset = function() {
          return suras.result = [];
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
