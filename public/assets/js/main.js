
/*global define, require
*/


(function() {

  require.config({
    urlArgs: "v=" + (new Date()).getTime(),
    paths: {
      'jquery': 'libs/jquery',
      'lodash': 'libs/lodash',
      'backbone': 'libs/backbone',
      'underscore.string': 'libs/underscore.string',
      'string-format': 'libs/string-format'
    },
    shim: {
      'libs/angular': {
        exports: 'angular'
      },
      'libs/angular-resource': {
        deps: ['libs/angular']
      },
      'libs/angular-ui': {
        deps: ['libs/angular']
      },
      'libs/backbone': {
        deps: ['lodash', 'jquery'],
        exports: 'Backbone'
      },
      'underscore.string': {
        deps: ['lodash']
      },
      'libs/keymaster': {
        exports: 'key'
      }
    }
  });

  require(['app', 'bootstrap', 'qurandata', 'controllers/quran-index', 'controllers/sura', 'directives/href', 'directives/button', 'filters/quran', 'responseInterceptors/dispatcher'], function(app) {
    var html5, tpl;
    tpl = function(name) {
      return "/partials/" + name + ".html?v=" + ((new Date).getTime());
    };
    app.value('html5', (html5 = true));
    app.config([
      '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
        $locationProvider.html5Mode(html5);
        return $routeProvider.when('/', {
          controller: 'quranIndex',
          templateUrl: tpl('quran-index'),
          reloadOnSearch: true
        }).when('/index/:sort', {
          controller: 'quranIndex',
          templateUrl: tpl('quran-index'),
          reloadOnSearch: true
        }).when('/sura/:suraId', {
          controller: 'sura',
          templateUrl: tpl('sura'),
          reloadOnSearch: true
        }).otherwise({
          redirectTo: '/'
        });
      }
    ]);
    return app.run([
      '$rootScope', '$log', function($rootScope, $log) {
        return $rootScope.$on('$routeChangeSuccess', function(event, currentRoute, priorRoute) {
          return $rootScope.$broadcast("" + currentRoute.controller + "$routeChangeSuccess", currentRoute, priorRoute);
        });
      }
    ]);
  });

}).call(this);
