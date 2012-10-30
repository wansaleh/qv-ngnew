###global define###

define [
  'libs/angular'
  'libs/backbone'
  'services/services'
  'services/message'
  'services/quran'
  'libs/angular-resource'
],

(angular, Backbone, services) ->
  'use strict'

  services.factory 'sura',
  ['$http', '$resource', 'message', 'quran',
  ($http, $resource, message, quran) ->

    class Ayas extends Backbone.Collection
      url: '/api/ayas.json'
      comparator: (aya) -> aya.get 'aya'

    ayas =
      result: []
      ids: []
      collection: new Ayas

    ayas.collection.on 'reset', (res) ->
      ayas.result = res.toJSON()
    ayas.collection.on 'add', (res) ->
      ayas.result.push res.toJSON()

    activity = $resource '/api/ayas.json'

    fetch = (suraId, success = angular.noop) ->
      $win = $(window)
      $doc = $(document)

      console.group 'sura service:', suraId

      # stop scroll event
      $win.off 'scroll', _lazyloader

      suraInfo = quran.suras.get(suraId)

      _offset = ->
        if last = ayas.collection.last() then last.get('aya') else 0

      _query = ->
        console.log 'start sura:', suraId, 'aya:', _offset()+1

        activity.query
          sura_id: suraId
          offset: _offset()
          limit: 20
        , (resource, headers) ->
          ayas.collection.add(resource)

          # attach scroll event
          $win.on 'scroll', _lazyloader
          success()

      _lazyloader = _.throttle ->
        _query() if $win.scrollTop() > $doc.height() - $win.height() and
          _offset() < suraInfo.get 'ayas'
      , 200

      _query()

      console.groupEnd()

    reset = ->
      ayas.result = []
      ayas.ids = []
      ayas.collection.reset()

    fetch: fetch
    reset: reset
    ayas: ayas
    activity: activity
  ]