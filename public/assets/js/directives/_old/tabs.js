
/*global define
*/


(function() {

  define(['libs/angular', 'directives/directives', 'libs/text!directives/templates/tabs.html'], function(angular, directives, template) {
    'use strict';
    return directives.directive('appTabs', [
      function() {
        var controller;
        controller = [
          '$scope', '$element', '$rootScope', function($scope, $element, $rootScope) {
            $scope.tabs = [];
            $scope.select = function(tab) {
              if (tab.selected === true) {
                return;
              }
              angular.forEach($scope.tabs, function(tab) {
                return tab.selected = false;
              });
              return tab.selected = true;
            };
            return this.addTab = function(tab, tabId) {
              if ($scope.tabs.length === 0) {
                $scope.select(tab);
              }
              $scope.tabs.push(tab);
              if (tabId) {
                return $rootScope.$on("changeTab#" + tabId, function() {
                  return $scope.select(tab);
                });
              }
            };
          }
        ];
        return {
          controller: controller,
          replace: true,
          restrict: 'E',
          scope: {},
          template: template,
          transclude: true
        };
      }
    ]);
  });

}).call(this);
