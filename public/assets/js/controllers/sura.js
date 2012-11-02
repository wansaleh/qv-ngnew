
/*global define
*/


(function() {

  define(['jquery', 'app', 'controllers/controllers', 'services/quran', 'services/sura'], function($, app, controllers) {
    'use strict';
    app.value('ui.config', {
      jq: {
        tooltip: {
          placement: 'bottom'
        }
      }
    });
    return controllers.controller('sura', [
      '$scope', '$rootScope', '$location', '$routeParams', 'quran', 'sura', function($scope, $rootScope, $location, $routeParams, quran, sura) {
        console.group('sura controller: sura:', $routeParams.suraId);
        $('body').stop().scrollTo({
          duration: 0
        });
        $(window).off('scroll');
        $scope.suraInfo = quran.suras.get($routeParams.suraId);
        if ($scope.suraInfo.toJSON != null) {
          $scope.suraInfo = $scope.suraInfo.toJSON();
        }
        $scope.ayas = sura.ayas;
        $rootScope.pageTitle = $scope.suraInfo.tname;
        sura.reset();
        sura.fetch($routeParams.suraId, function() {
          _.defer(function() {
            var hash;
            if (hash = $location.hash()) {
              return $("#" + hash).stop().scrollTo({
                offset: -100
              });
            }
          });
          return $scope.overlay = false;
        });
        $scope.top = function() {
          if ($(window).scrollTop() > 100) {
            return $('body').stop().scrollTo();
          }
        };
        return console.groupEnd();
      }
    ]);
  });

}).call(this);
