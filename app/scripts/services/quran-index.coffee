###global define###

define [
  'libs/angular'
  'libs/backbone'
  'libs/store'
  'services/services'
  'services/message'
  'services/quran'
  'libs/angular-resource'
],

(angular, Backbone, store, services) ->
  'use strict'

  services.factory 'quranIndex',
  ['$resource', 'message', 'quran',
  ($resource, message, quran) ->

    Suras = Backbone.Collection.extend
      url: '/api/suras.js'
      comparator: (sura) -> sura.get 'id'

    suras =
      result: []
      collection: new Suras

    suras.collection.on 'reset', (res) ->
      suras.result = res.toJSON()

    activity = $resource '/api/suras.json'

    fetch = (success = angular.noop) ->
      if _.isUndefined(suras_store = store.get('suras.result'))
        activity.query (resource, headers) ->
          suras.collection.reset(resource)
          store.set('suras.result', resource)
          success()
      else
        suras.collection.reset(suras_store)

    reset = ->
      suras.result = []
      suras.collection.reset()

    fetch: fetch
    reset: reset
    suras: suras
    activity: activity
  ]