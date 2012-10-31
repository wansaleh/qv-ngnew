
/*global define
*/


(function() {

  define(['libs/angular', 'services/services', 'services/message', 'services/quran', 'libs/angular-resource'], function(angular, services) {
    'use strict';
    return services.factory('sura', [
      '$http', '$resource', 'message', 'quran', function($http, $resource, message, quran) {
        var activity, ayas, fetch, reset;
        ayas = {
          result: [],
          ids: []
        };
        activity = $resource('/api/ayas.json');
        fetch = function(suraId, success) {
          var $doc, $win, suraInfo, _lazyloader, _offset, _query;
          if (success == null) {
            success = angular.noop;
          }
          $win = $(window);
          $doc = $(document);
          console.group('sura service:', suraId);
          $win.off('scroll', _lazyloader);
          suraInfo = quran.suras.get(suraId);
          _offset = function() {
            var last;
            if (last = _(ayas.result).last()) {
              return last.aya;
            } else {
              return 0;
            }
          };
          _query = function() {
            console.log('start sura:', suraId, 'aya:', _offset() + 1);
            return activity.query({
              sura_id: suraId,
              offset: _offset(),
              limit: 20
            }, function(resource, headers) {
              resource.forEach(function(res) {
                if (!_.contains(ayas.ids, res.id)) {
                  ayas.result.push(res);
                  return ayas.ids.push(res.id);
                }
              });
              $win.on('scroll', _lazyloader);
              return success();
            });
          };
          _lazyloader = _.throttle(function() {
            if ($win.scrollTop() > $doc.height() - $win.height() && _offset() < suraInfo.get('ayas')) {
              return _query();
            }
          }, 200);
          _query();
          return console.groupEnd();
        };
        reset = function() {
          ayas.result = [];
          return ayas.ids = [];
        };
        return {
          fetch: fetch,
          reset: reset,
          ayas: ayas,
          activity: activity
        };
      }
    ]);
  });

}).call(this);
