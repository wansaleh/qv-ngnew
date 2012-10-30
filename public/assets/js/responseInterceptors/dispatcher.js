
/*global define
*/


(function() {

  define(['responseInterceptors/responseInterceptors', 'statuses'], function(responseInterceptors, statuses) {
    'use strict';
    return responseInterceptors.config([
      '$httpProvider', function($httpProvider) {
        return $httpProvider.responseInterceptors.push([
          '$rootScope', '$q', function($rootScope, $q) {
            var error, success;
            success = function(response) {
              var status;
              status = statuses[response.status];
              $rootScope.$broadcast("success:" + response.status, response);
              if (status) {
                $rootScope.$broadcast("success:" + status, response);
              }
              return response;
            };
            error = function(response) {
              var deferred, status;
              status = statuses[response.status];
              deferred = $q.defer();
              $rootScope.$broadcast("error:" + response.status, response);
              if (status) {
                $rootScope.$broadcast("error:" + status, response);
              }
              deferred.promise();
              return $q.reject(response);
            };
            return function(promise) {
              return promise.then(success, error);
            };
          }
        ]);
      }
    ]);
  });

}).call(this);
