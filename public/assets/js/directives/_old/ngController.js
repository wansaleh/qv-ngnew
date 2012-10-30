
/*global define
*/


(function() {

  define(['directives/directives'], function(directives) {
    'use strict';
    return directives.directive('ngController', [
      '$rootScope', function($rootScope) {
        var link;
        link = function(scope, element, attrs, controller) {
          return $rootScope.$on("" + attrs.ngController + "$routeChangeSuccess", function(event, currentRoute, priorRoute) {
            if (scope.onRouteChange) {
              return scope.onRouteChange(currentRoute.params);
            }
          });
        };
        return {
          link: link,
          restrict: 'A'
        };
      }
    ]);
  });

}).call(this);
