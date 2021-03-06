define ['jquery', 'libs/meny', 'app', 'controllers/controllers', 'services/quran', 'services/sura'],
!($, Meny, app, controllers) ->
  'use strict'

  controllers.controller 'sura',
  ['$scope', '$rootScope', '$location', '$routeParams', 'quran', 'sura', 'index',
  !($scope, $rootScope, $location, $routeParams, quran, sura, index) ->

    console.group 'sura controller - sura:', $routeParams.sura
    console.info 'start aya:', $routeParams.aya

    # back to top
    window.scrollTo 0, 0

    # remove any scroll event
    $ window .off 'scroll'

    # ========================================================================
    # models

    $scope.suraInfo = quran.suras.get $routeParams.sura
    $scope.suraInfo = $scope.suraInfo.toJSON! if $scope.suraInfo.toJSON?
    $scope.ayas = sura.ayas
    $scope.suras = index.suras

    # set title
    $rootScope.pageTitle = $scope.suraInfo.tname

    # reset ayas collection
    sura.reset!

    $scope.overlay = true
    sura.fetch $routeParams.sura, $routeParams.aya, ->
      $scope.overlay = false

    $scope.currentAya = $routeParams.aya || 1

    # ========================================================================
    # functions

    $scope.top = ->
      $ 'body' .scrl! if $ window .scrollTop! > 100

    # ========================================================================
    # events

    # unbind key events
    $ document .off 'keypress' .off 'keyup'

    _.defer ->
      # hide empty ng-scopes
      $ 'span.ng-scope' .each ->
        $ this .remove! if !$ this .html!.trim!.length
        # $ this .hide! if !$ this .html!.trim!.length

    console.groupEnd!

  ]