
/*global define
*/


(function() {

  define(['controllers/controllers', 'services/quran', 'services/sura'], function(controllers) {
    'use strict';
    return controllers.controller('sura', [
      '$scope', '$rootScope', '$routeParams', 'quran', 'sura', function($scope, $rootScope, $routeParams, quran, sura) {
        console.group('sura controller: sura:', $routeParams.suraId);
        $scope.suraInfo = quran.suras.get($routeParams.suraId);
        $scope.ayas = sura.ayas;
        $rootScope.pageTitle = $scope.suraInfo.tname;
        sura.reset();
        sura.fetch($routeParams.suraId);
        $scope.juz = function(aya) {
          var juz;
          juz = _.first(quran.juzs.where({
            sura: aya.sura_id,
            aya: aya.aya
          }));
          if (juz != null) {
            return juz.id;
          } else {
            return false;
          }
        };
        $scope.sajda = function(aya) {
          var sajda;
          sajda = _.first(quran.sajdas.where({
            sura: aya.sura_id,
            aya: aya.aya
          }));
          sajda = (function() {
            if (!sajda) {
              return 0;
            } else {
              switch (sajda.get('hukm')) {
                case 'recommended':
                  return 1;
                case 'obligatory':
                  return 2;
              }
            }
          })();
          return sajda;
        };
        return console.groupEnd();
      }
    ]);
  });

}).call(this);
