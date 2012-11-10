define ['lodash', 'utils', 'directives/directives'],
(_, utils, directives) ->
  'use strict'

  msie = _.int (/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1]

  directives.directive 'myHref', ['html5', (html5) ->
    priority: 99, # it needs to run after the attributes are interpolated
    link: (scope, element, attr) ->
      attr.$observe 'myHref', (value) ->
        return if !value
        value = (if html5 then '/' else '/#/') + value.replace(/^\/+/, '')
        attr.$set('href', value)
        element.prop('href', value) if msie
  ]

  directives.directive 'myTitle', ->
    priority: 99, # it needs to run after the attributes are interpolated
    link: (scope, element, attr) ->
      attr.$observe 'myTitle', (value) ->
        return if !value
        attr.$set('title', value)
        element.prop('title', value) if msie

  directives.directive 'clearInput', [->
    restrict: 'A'
    link: (scope, element, attrs) ->
      button = $('<button class="clear-input"><i class="icon-remove-circle"></i></button>').hide()
      button.on 'click', ->
        scope.$apply -> scope.clearFilter()

      element.after(button)

      scope.$watch 'filterText', (val) ->
        button[if val.length > 0 then 'show' else 'hide']()
  ]