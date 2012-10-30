
/*global define
*/


(function() {

  define(['libs/store', 'controllers/controllers', 'services/quran', 'services/quran-index'], function(store, controllers) {
    'use strict';
    return controllers.controller('quranIndex', [
      '$scope', '$rootScope', '$routeParams', '$filter', 'quran', 'quranIndex', function($scope, $rootScope, $routeParams, $filter, quran, quranIndex) {
        var sortToggles, _nextSort;
        console.group('quranIndex controller');
        $(window).off('scroll');
        $rootScope.pageTitle = "Index";
        $scope.suras = quranIndex.suras;
        quranIndex.fetch();
        $scope.sort = {
          attr: 'id',
          desc: false
        };
        $scope.search = '';
        sortToggles = ['id', 'tname', 'order', 'ayas:desc'];
        _nextSort = function(attr) {
          var next, sort, _ref;
          next = _.indexOf(sortToggles, attr) + 1;
          next = next >= sortToggles.length ? 0 : next;
          sort = sortToggles[next].split(':');
          if ((_ref = sort[1]) == null) {
            sort[1] = false;
          }
          return {
            attr: sort[0],
            desc: sort[1] === 'desc'
          };
        };
        $scope.changeSorting = function(attr, desc) {
          if ($scope.sort.attr === attr) {
            desc = !$scope.sort.desc;
          }
          $scope.sort.attr = attr;
          return $scope.sort.desc = desc || false;
        };
        $scope.toggleSorting = function() {
          var next;
          next = _nextSort($scope.sort.attr);
          return $scope.sort = next;
        };
        $scope.isSorting = function(attr, dir) {
          if (dir != null) {
            return $scope.sort.attr === attr && $scope.sort.desc === dir;
          } else {
            return $scope.sort.attr === attr;
          }
        };
        $scope.filter = function() {
          if ($scope.search.length >= 2) {
            return $scope.search;
          } else {
            return '';
          }
        };
        $scope.filtered = function() {
          return $filter('filter')($scope.suras.result, $scope.filter());
        };
        $scope.clearSearch = function() {
          return $scope.search = '';
        };
        return console.groupEnd();
      }
    ]);
  });

}).call(this);
