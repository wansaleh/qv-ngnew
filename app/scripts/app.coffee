define [
  # essentials
  'libs/angular'
  'libs/angular-resource'
  # 'libs/angular-ui'
  'jquery'
  'lodash'
  'underscore.string'

  # others
  'qurandata'
  'utils'
  'quranutils'

  # modules
  'controllers/controllers'
  'directives/directives'
  'filters/filters'
  'responseInterceptors/responseInterceptors'
  'services/services'
],

(angular) ->
  'use strict'

  angular.module 'app', [
    # 'ui'
    'ngResource'
    'controllers'
    'directives'
    'filters'
    'responseInterceptors'
    'services'
  ]
