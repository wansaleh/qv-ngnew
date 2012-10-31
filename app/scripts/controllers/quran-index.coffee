###global define###

define ['libs/store', 'libs/keymaster', 'controllers/controllers', 'services/quran', 'services/quran-index'],

(store, key, controllers) ->
  'use strict'

  controllers.controller 'quranIndex',
  ['$scope', '$rootScope', '$routeParams', '$filter', 'quran', 'quranIndex'
  ($scope, $rootScope, $routeParams, $filter, quran, quranIndex) ->

    console.group 'quranIndex controller'

    # remove any scroll event
    $(window).off 'scroll'

    # $scope.suras = result: []
    # $scope.suras.result = quran.suras

    $rootScope.pageTitle = "Index"

    $scope.suras = quranIndex.suras
    quranIndex.fetch()

    $scope.sort =
      attr: 'id'
      desc: false

    $scope.search = ''

    sortToggles = ['id', 'tname', 'order', 'ayas:desc']

    _nextSort = (attr) ->
      next = _.indexOf(sortToggles, attr) + 1
      next = if next >= sortToggles.length then 0 else next
      sort = sortToggles[next].split ':'
      sort[1] ?= false

      attr: sort[0]
      desc: sort[1] == 'desc'

    $scope.changeSorting = (attr, desc) ->
      # reverse dir if sorting with old attr
      desc = !$scope.sort.desc if $scope.sort.attr == attr

      $scope.sort.attr = attr
      $scope.sort.desc = desc || false

    $scope.toggleSorting = ->
      next = _nextSort $scope.sort.attr
      $scope.sort = next

    $scope.isSorting = (attr, dir) ->
      if dir?
        $scope.sort.attr == attr and $scope.sort.desc == dir
      else
        $scope.sort.attr == attr

    $scope.filter = ->
      if $scope.search.length >= 2 then $scope.search else ''

    $scope.filtered = ->
      $filter('filter')($scope.suras.result, $scope.filter())

    $scope.clearSearch = ->
      $scope.search = ''

    console.groupEnd()

  ]