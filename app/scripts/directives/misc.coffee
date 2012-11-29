define ['lodash', 'utils', 'directives/directives'],
(_, utils, directives) ->
  'use strict'

  msie = _.int (/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1]

  # myHref
  # ============================================================================
  directives.directive 'myHref', ['html5', (html5) ->
    priority: 99, # it needs to run after the attributes are interpolated
    link: (scope, element, attr) ->
      attr.$observe 'myHref', (value) ->
        return if !value
        value = (if html5 then '/' else '/#/') + value.replace(/^\/+/, '')
        attr.$set('href', value)
        element.prop('href', value) if msie
  ]

  # myTitle
  # ============================================================================
  directives.directive 'myTitle', ->
    priority: 99, # it needs to run after the attributes are interpolated
    link: (scope, element, attr) ->
      attr.$observe 'myTitle', (value) ->
        return if !value
        attr.$set('title', value)
        element.prop('title', value) if msie

  # clearInput
  # ============================================================================
  directives.directive 'clearInput', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      button = angular.element('<button class="clear-input"><i class="icon-remove-circle"></i></button>').hide()
      button.on 'click', ->
        scope.$apply -> scope.clearFilter()

      element.after(button)

      scope.$watch 'filterText', (val) ->
        button[if val.length > 0 then 'show' else 'hide']()

  # if
  # ============================================================================
  directives.directive 'if', [->
    transclude: 'element'
    priority: 1000
    terminal: true
    restrict: 'A'
    compile: (element, attr, linker) ->
      (scope, iterStartElement, attr) ->
        iterStartElement[0].doNotMove = true
        expression = attr.if
        lastElement = undefined
        lastScope = undefined
        scope.$watch expression, (newValue) ->
          if lastElement
            lastElement.remove()
            lastElement = null
          if lastScope
            lastScope.$destroy()
            lastScope = null
          if newValue
            lastScope = scope.$new()
            linker lastScope, (clone) ->
              lastElement = clone
              iterStartElement.after clone


          # Note: need to be parent() as jquery cannot trigger events on comments
          # (angular creates a comment node when using transclusion, as ng-repeat does).
          iterStartElement.parent().trigger '$childrenChanged'
  ]

  # scrollTop
  # ============================================================================
  directives.directive 'scrollTop', ->
    priority: 99, # it needs to run after the attributes are interpolated
    link: (scope, element, attr) ->
      $menu = angular.element('.sura-menu')
      scope.$watch attr.scrollTop, (newValue) ->
        $menu.scrollTop(element.position().top) if _.bool(newValue)
