define ['jquery', 'libs/store', 'controllers/controllers', 'services/quran', 'services/index'],
($, store, controllers) ->
  'use strict'

  controllers.controller 'index',
  ['$scope', '$rootScope', '$routeParams', '$filter', 'quran', 'index'
  ($scope, $rootScope, $routeParams, $filter, quran, index) ->

    console.group 'index controller'

    # back to top
    window.scrollTo 0, 0

    # remove any scroll event
    $(window).off 'scroll'

    # ========================================================================
    # models

    # set title
    $rootScope.pageTitle = 'Index'

    # suras
    $scope.suras = index.suras

    # sort attrs
    $scope.sort =
      attr: 'id'
      desc: false

    # filter string
    $scope.filterText = ''

    sortToggles = ['id', 'tname', 'order', 'ayas:desc']

    $searchBox = $('#filter')

    # ========================================================================
    # functions

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

    $scope.filtered = ->
      $filter('filter') $scope.suras.result, $scope.filterText

    $scope.clearFilter = ->
      $scope.filterText = ''

    $scope.focusSearch = ->
      $searchBox.focus()

    # ========================================================================
    # events

    $(document).on 'keypress', (e) ->
      # focus the seach box on keypress
      if !$searchBox.is(":focus")
        key = String.fromCharCode e.keyCode
        if /[a-zA-Z0-9]/.test(key)
          $scope.filterText = key
          $searchBox.focus()

    $(document).on 'keyup', (e) ->
      if e.keyCode == 27
        $searchBox.blur()
        $scope.$apply -> $scope.clearFilter()

    $('.search-result').on 'mousedown', (e) ->
      $searchBox.focus()
      e.stopPropagation()
      false

    console.groupEnd()

  ]