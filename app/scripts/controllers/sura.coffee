###global define###

define ['jquery', 'app', 'controllers/controllers', 'services/quran', 'services/sura'],

($, app, controllers) ->
  'use strict'

  controllers.controller 'sura',
  ['$scope', '$rootScope', '$location', '$routeParams', 'quran', 'sura',
  ($scope, $rootScope, $location, $routeParams, quran, sura) ->

    console.group 'sura controller: sura:', $routeParams.suraId

    # back to top
    $('body').stop().scrollTo(duration: 0)

    # remove any scroll event
    $(window).off 'scroll'

    # ========================================================================
    # models

    $scope.suraInfo = quran.suras.get($routeParams.suraId)
    $scope.suraInfo = $scope.suraInfo.toJSON() if $scope.suraInfo.toJSON?
    $scope.ayas = sura.ayas

    # set title
    $rootScope.pageTitle = $scope.suraInfo.tname

    # reset ayas collection
    sura.reset()

    # $scope.overlay = true
    sura.fetch $routeParams.suraId, ->
      _.defer ->
        if hash = $location.hash()
          $("##{hash}").stop().scrollTo(offset: -100)

      $scope.overlay = false

    # ========================================================================
    # functions

    $scope.top = ->
      $('body').stop().scrollTo() if $(window).scrollTop() > 100

    # $scope.showSuras = ->
    #   $('#topnav').addClass('slideup')

    # $scope.hideSuras = ->
    #   $('#topnav').removeClass('slideup')

    console.groupEnd()

  ]