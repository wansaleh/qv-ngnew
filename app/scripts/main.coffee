require.config
  urlArgs: "v=" + (new Date()).getTime()

  paths:
    # all named library definitions goes here
    'jquery': 'libs/jquery'
    'lodash': 'libs/lodash'
    'underscore.string': 'libs/underscore.string'
    'string-format': 'libs/string-format'

  shim:
    'libs/angular':          deps: ['jquery'], exports: 'angular'
    'libs/angular-resource': deps: ['libs/angular']
    'libs/angular-ui':       deps: ['libs/angular']
    'libs/backbone':         deps: ['lodash', 'jquery'], exports: 'Backbone'
    'underscore.string':     deps: ['lodash']
    'libs/bootstrap':        deps: ['jquery']

require [
  # essentials
  'app'
  'bootstrap'
  'plugins'
  'qurandata'
  'utils'
  'quranutils'

  # controllers
  'controllers/index'
  'controllers/sura'

  # directives
  'directives/view'
  'directives/misc'
  'directives/button'

  # filters
  'filters/quran'

  # responseInterceptors
  'responseInterceptors/dispatcher'
],

(app) ->

  tpl = (name) -> "/partials/#{name}.html?v=#{(new Date).getTime()}"

  app.value 'html5', (html5 = true)

  # Route configuration
  app.config ['$routeProvider', '$locationProvider'
  ($routeProvider, $locationProvider) ->

    $locationProvider.html5Mode html5

    $routeProvider
      .when '/'
        controller: 'index'
        templateUrl: tpl 'quran'
        reloadOnSearch: true

      .when '/index/:sort'
        controller: 'index'
        templateUrl: tpl 'quran'
        reloadOnSearch: true

      .when '/sura/:sura'
        controller: 'sura'
        templateUrl: tpl 'sura'
        reloadOnSearch: true

      .when '/sura/:sura/:aya'
        controller: 'sura'
        templateUrl: tpl 'sura'
        reloadOnSearch: true

      .otherwise
        redirectTo: '/'
  ]

  app.run ['$rootScope', '$log', ($rootScope, $log) ->
    $rootScope.$on 'error:unauthorized', (event, response) ->
      $log.error 'unauthorized'

    $rootScope.$on 'error:forbidden', (event, response) ->
      $log.error 'forbidden'

    $rootScope.$on 'error:403', (event, response) ->
      $log.error '403'

    $rootScope.$on 'success:ok', (event, response) ->
      $log.info 'success'

    # fire an event related to the current route
    $rootScope.$on '$routeChangeSuccess', (event, currentRoute, priorRoute) ->
      $rootScope.$broadcast "#{currentRoute.controller}$routeChangeSuccess",
        currentRoute, priorRoute
  ]