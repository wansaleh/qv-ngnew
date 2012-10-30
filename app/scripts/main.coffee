###global define, require###

require.config
  urlArgs: "v=" + (new Date()).getTime()

  paths:

    # all named library definitions goes here
    'jquery': 'libs/jquery'
    'lodash': 'libs/lodash'
    'backbone': 'libs/backbone'
    'underscore.string': 'libs/underscore.string'
    'string-format': 'libs/string-format'

  shim:
    'libs/angular':
      exports: 'angular'

    'libs/angular-resource':
      deps: ['libs/angular']

    'libs/angular-ui':
      deps: ['libs/angular']

    'libs/backbone':
      deps: ['lodash', 'jquery']
      exports: 'Backbone'

    'underscore.string':
      deps: ['lodash']

require [
  'app'
  'jquery'
  'bootstrap'
  'utils'
  'qurandata'
  'controllers/quran-index'
  'controllers/sura'
  'directives/myHref'
  'directives/tbbutton'
  'filters/quran'
  'responseInterceptors/dispatcher'
],

(app, $) ->

  tpl = (name) -> "/partials/#{name}.html?v=#{(new Date).getTime()}"

  app.value 'html5', (html5 = true)

  # Route configuration
  app.config ['$routeProvider', '$locationProvider'
  ($routeProvider, $locationProvider) ->

    $locationProvider.html5Mode html5

    $routeProvider
      .when '/'
        controller: 'quranIndex'
        templateUrl: tpl 'quran-index'
        reloadOnSearch: true

      .when '/index/:sort'
        controller: 'quranIndex'
        templateUrl: tpl 'quran-index'
        reloadOnSearch: true

      .when '/sura/:suraId'
        controller: 'sura'
        templateUrl: tpl 'sura'
        reloadOnSearch: true

      .otherwise
        redirectTo: '/'
  ]

  app.run ['$rootScope', '$log', ($rootScope, $log) ->
    # $rootScope.$on 'error:unauthorized', (event, response) ->
    #   $log.error 'unauthorized'

    # $rootScope.$on 'error:forbidden', (event, response) ->
    #   $log.error 'forbidden'

    # $rootScope.$on 'error:403', (event, response) ->
    #   $log.error '403'

    # $rootScope.$on 'success:ok', (event, response) ->
    #   $log.info 'success'

    # fire an event related to the current route
    $rootScope.$on '$routeChangeSuccess', (event, currentRoute, priorRoute) ->
      $rootScope.$broadcast "#{currentRoute.controller}$routeChangeSuccess",
        currentRoute, priorRoute
  ]