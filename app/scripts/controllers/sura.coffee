define ['jquery', 'app', 'controllers/controllers', 'services/quran', 'services/sura'],

($, app, controllers) ->
  'use strict'

  controllers.controller 'sura',
  ['$scope', '$rootScope', '$location', '$routeParams', 'quran', 'sura', 'index',
  ($scope, $rootScope, $location, $routeParams, quran, sura, index) ->

    console.group 'sura controller - sura:', $routeParams.sura
    console.info 'start aya:', $routeParams.aya

    # back to top
    $('body').scrollTo(duration: 0)

    # ========================================================================
    # models

    $scope.suraInfo = quran.suras.get($routeParams.sura)
    $scope.suraInfo = $scope.suraInfo.toJSON() if $scope.suraInfo.toJSON?
    $scope.ayas = sura.ayas
    $scope.suras = index.suras

    # set title
    $rootScope.pageTitle = $scope.suraInfo.tname

    # reset ayas collection
    sura.reset()

    $scope.overlay = true
    sura.fetch $routeParams.sura, $routeParams.aya, -> $scope.overlay = false

    $scope.$watch 'ayas.loaded', ->
      console.log 'Ayas loaded:', $scope.ayas.loaded

    $scope.currentAya = $routeParams.aya || 1

    # ========================================================================
    # functions

    $scope.top = ->
      $('body').scrollTo() if $(window).scrollTop() > 100

    # ========================================================================
    # events

    # remove any scroll event
    $(window).off 'scroll'

    # unbind key events
    $(document).off('keypress').off('keyup')

    console.groupEnd()

  ]