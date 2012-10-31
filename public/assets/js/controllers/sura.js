
/*global define
*/


(function() {

  define(['controllers/controllers', 'services/quran', 'services/sura'], function(controllers) {
    'use strict';
    return controllers.controller('sura', [
      '$scope', '$rootScope', '$routeParams', 'quran', 'sura', function($scope, $rootScope, $routeParams, quran, sura) {
        console.group('sura controller: sura:', $routeParams.suraId);
        $scope.suraInfo = quran.suras.get($routeParams.suraId);
        if (_.isUndefined($scope.suraInfo.tname)) {
          $scope.suraInfo = $scope.suraInfo.toJSON();
        }
        $rootScope.pageTitle = $scope.suraInfo.tname;
        $scope.ayas = sura.ayas;
        sura.reset();
        sura.fetch($routeParams.suraId);
        return console.groupEnd();
      }
    ]);
  });

}).call(this);
