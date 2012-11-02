
/*global define
*/


(function() {

  define(['jquery', 'app', 'controllers/controllers', 'services/quran', 'services/sura', 'libs/bootstrap'], function($, app, controllers) {
    'use strict';
    app.value('ui.config', {
      jq: {
        tooltip: {
          placement: 'bottom'
        }
      }
    });
    return controllers.controller('sura', [
      '$scope', '$rootScope', '$routeParams', 'quran', 'sura', function($scope, $rootScope, $routeParams, quran, sura) {
        console.group('sura controller: sura:', $routeParams.suraId);
        $scope.suraInfo = quran.suras.get($routeParams.suraId);
        if ($scope.suraInfo.toJSON != null) {
          $scope.suraInfo = $scope.suraInfo.toJSON();
        }
        $rootScope.pageTitle = $scope.suraInfo.tname;
        $scope.ayas = sura.ayas;
        sura.reset();
        $scope.overlay = true;
        sura.fetch($routeParams.suraId, function() {
          return $scope.overlay = false;
        });
        return console.groupEnd();
      }
    ]);
  });

}).call(this);
