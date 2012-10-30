###global define###

define ['directives/directives'],
(directives) ->
  'use strict'

  msie = parseInt((/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1], 10)

  directives.directive 'myHref', ['html5', (html5) ->
    priority: 99, # it needs to run after the attributes are interpolated
    link: (scope, element, attr) ->
      attr.$observe 'myHref', (value) ->
        return if !value

        value = (if html5 then '/' else '/#/') + value.replace(/^\/+/, '')

        attr.$set('href', value)

        # on IE, if "ng:src" directive declaration is used and "src" attribute doesn't exist
        # then calling element.setAttribute('src', 'foo') doesn't do anything, so we need
        # to set the property as well to achieve the desired effect
        element.prop('href', value) if msie
  ]