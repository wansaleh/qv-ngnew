###global define###

define [
  'libs/angular'
  'libs/store'
  'services/services'
  'services/message'
  'services/quran'
  'libs/angular-resource'
],

(angular, store, services) ->
  'use strict'

  services.factory 'quranIndex',
  ['$resource', 'message', 'quran',
  ($resource, message, quran) ->

    suras =
      result: []

    activity = $resource '/api/suras.json'

    fetch = (success = angular.noop) ->
      if _.isUndefined(suras_store = store.get('suras.result'))
        suras.result = activity.query (resource, headers) ->
          store.set('suras.result', resource)
          success()
      else
        suras.result = suras_store

    reset = ->
      suras.result = []

    fetch: fetch
    reset: reset
    suras: suras
    activity: activity
  ]