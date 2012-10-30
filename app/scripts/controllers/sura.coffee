###global define###

define ['controllers/controllers', 'services/quran', 'services/sura'],

(controllers) ->
  'use strict'

  controllers.controller 'sura',
  ['$scope', '$rootScope', '$routeParams', 'quran', 'sura',
  ($scope, $rootScope, $routeParams, quran, sura) ->

    console.group 'sura controller: sura:', $routeParams.suraId

    $scope.suraInfo = quran.suras.get($routeParams.suraId)
    $scope.ayas     = sura.ayas

    $rootScope.pageTitle = $scope.suraInfo.tname

    sura.reset()
    sura.fetch $routeParams.suraId

    $scope.juz = (aya) ->
      juz = _.first quran.juzs.where(sura: aya.sura_id, aya: aya.aya)
      if juz? then juz.id else false

    $scope.sajda = (aya) ->
      # sajda => 0=n/a 1=recommended 2=obligatory
      sajda = _.first quran.sajdas.where(sura: aya.sura_id, aya: aya.aya)
      sajda = if !sajda then 0 else switch sajda.get('hukm')
        when 'recommended' then 1
        when 'obligatory'  then 2
      sajda

    # $scope.showSuras = ->
    #   $('#topnav').addClass('slideup')

    # $scope.hideSuras = ->
    #   $('#topnav').removeClass('slideup')

    console.groupEnd()

  ]