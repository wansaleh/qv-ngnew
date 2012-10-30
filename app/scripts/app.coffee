###global define###

define [
	'libs/angular'
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
