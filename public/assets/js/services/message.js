
/*global define
*/


(function() {

  define(['services/services'], function(services) {
    'use strict';
    return services.factory('message', [
      '$rootScope', function($rootScope) {
        var publish, subscribe;
        publish = function(name, parameters) {
          parameters.timeStamp = new Date();
          return $rootScope.$broadcast(name, parameters);
        };
        subscribe = function(name, listener) {
          return $rootScope.$on(name, listener);
        };
        return {
          publish: publish,
          subscribe: subscribe
        };
      }
    ]);
  });

}).call(this);
