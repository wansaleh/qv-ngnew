###global define###

define ['lodash', 'utils', 'directives/directives'],
(_, utils, directives) ->
  'use strict'

  msie = _.to_i((/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1])

  directives.directive 'qvHref', ['html5', (html5) ->
    priority: 99, # it needs to run after the attributes are interpolated
    link: (scope, element, attr) ->
      attr.$observe 'qvHref', (value) ->
        return if !value

        value = (if html5 then '/' else '/#/') + value.replace(/^\/+/, '')

        attr.$set('href', value)

        # on IE, if "ng:href" directive declaration is used and "href" attribute doesn't exist
        # then calling element.setAttribute('href', 'foo') doesn't do anything, so we need
        # to set the property as well to achieve the desired effect
        element.prop('href', value) if msie
  ]