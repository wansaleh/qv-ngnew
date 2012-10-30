
/*global define
*/


(function() {

  define(['directives/directives', 'libs/text!directives/templates/tab.html', 'directives/tabs'], function(directives, template) {
    'use strict';
    return directives.directive('appTab', [
      function() {
        var link;
        link = function(scope, element, attrs, controller) {
          return controller.addTab(scope, attrs.tabId);
        };
        return {
          link: link,
          replace: true,
          require: '^appTabs',
          restrict: 'E',
          scope: {
            caption: '@'
          },
          template: template,
          transclude: true
        };
      }
    ]);
  });

}).call(this);
