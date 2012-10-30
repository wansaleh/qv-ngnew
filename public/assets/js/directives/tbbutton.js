
/*global define
*/


(function() {

  define(['directives/directives'], function(directives) {
    'use strict';

    var linker;
    linker = function(scope, element, attrs) {
      if (attrs["class"] != null) {
        element.addClass(attrs["class"]);
      }
      if (attrs.type != null) {
        return attrs.type.trim().split(/\s+/).forEach(function(cls) {
          return element.addClass("btn-" + cls);
        });
      }
    };
    directives.directive('btn', [
      function() {
        return {
          restrict: 'E',
          template: "<button class='btn' ng-transclude></button>",
          transclude: true,
          replace: true,
          link: linker
        };
      }
    ]);
    return directives.directive('abtn', [
      function() {
        return {
          restrict: 'E',
          template: "<a class='btn' ng-transclude></a>",
          transclude: true,
          replace: true,
          link: linker
        };
      }
    ]);
  });

}).call(this);
