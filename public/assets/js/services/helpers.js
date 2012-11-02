
/*global define
*/


(function() {

  define(['libs/angular', 'services/services', 'services/message', 'libs/angular-resource'], function(angular, services) {
    'use strict';
    return services.factory('helpers', [
      '$resource', 'message', function($resource, message) {
        var suraPermalink, suraValid;
        suraValid = function(id) {
          return (1 <= id && id <= 114);
        };
        suraPermalink = function(id) {
          if (!suraValid(id)) {
            return false;
          }
          return "/sura/" + id;
        };
        return {
          suraValid: suraValid,
          suraPermalink: suraPermalink
        };
      }
    ]);
  });

}).call(this);
