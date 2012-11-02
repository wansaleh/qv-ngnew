###global define###

define ['jquery', 'app', 'controllers/controllers', 'services/quran', 'services/sura', 'libs/bootstrap'],

($, app, controllers) ->
  'use strict'

  app.value 'ui.config',
    jq: tooltip: placement: 'bottom'

  controllers.controller 'sura',
  ['$scope', '$rootScope', '$routeParams', 'quran', 'sura',
  ($scope, $rootScope, $routeParams, quran, sura) ->

    console.group 'sura controller: sura:', $routeParams.suraId

    $scope.suraInfo = quran.suras.get($routeParams.suraId)

    $scope.suraInfo = $scope.suraInfo.toJSON() if $scope.suraInfo.toJSON?

    $rootScope.pageTitle = $scope.suraInfo.tname
    $scope.ayas = sura.ayas

    sura.reset()

    $scope.overlay = true
    sura.fetch $routeParams.suraId, ->
      $scope.overlay = false

    # $scope.showSuras = ->
    #   $('#topnav').addClass('slideup')

    # $scope.hideSuras = ->
    #   $('#topnav').removeClass('slideup')

    console.groupEnd()

  ]