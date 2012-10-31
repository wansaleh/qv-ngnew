###global define###

define [
	# essentials
	'libs/angular'
	'jquery'
	'lodash'
  'underscore.string'

  # others
  'utils'
	'libs/angular-resource'
	'libs/angular-ui'
	'controllers/controllers'
	'directives/directives'
	'filters/filters'
	'responseInterceptors/responseInterceptors'
	'services/services'
],

(angular) ->
	'use strict'

	angular.module 'app', [
		'ui'
		'controllers'
		'directives'
		'filters'
		'ngResource'
		'responseInterceptors'
		'services'
	]
