###global define###

define ['controllers/controllers', 'services/quran', 'services/sura'],

(controllers) ->
  'use strict'

  controllers.controller 'sura',
  ['$scope', '$rootScope', '$routeParams', 'quran', 'sura',
  ($scope, $rootScope, $routeParams, quran, sura) ->

    console.group 'sura controller: sura:', $routeParams.suraId

    $scope.suraInfo = quran.suras.get($routeParams.suraId)
    $scope.suraInfo = $scope.suraInfo.toJSON() if _.isUndefined $scope.suraInfo.tname

    $rootScope.pageTitle = $scope.suraInfo.tname
    $scope.ayas = sura.ayas

    sura.reset()
    sura.fetch $routeParams.suraId

    # $scope.showSuras = ->
    #   $('#topnav').addClass('slideup')

    # $scope.hideSuras = ->
    #   $('#topnav').removeClass('slideup')

    console.groupEnd()

  ]