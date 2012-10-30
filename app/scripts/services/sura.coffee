###global define###

define [
  'libs/angular'
  'services/services'
  'services/message'
  'services/quran'
  'libs/angular-resource'
],

(angular, services) ->
  'use strict'

  services.factory 'sura',
  ['$http', '$resource', 'message', 'quran',
  ($http, $resource, message, quran) ->

    ayas =
      result: []
      ids: []

    activity = $resource '/api/ayas.json'

    fetch = (suraId, success = angular.noop) ->
      $win = $(window)
      $doc = $(document)

      console.group 'sura service:', suraId

      # stop scroll event
      $win.off 'scroll', _lazyloader

      suraInfo = quran.suras.get(suraId)

      _offset = ->
        if last = _(ayas.result).last() then last.aya else 0

      _query = ->
        console.log 'start sura:', suraId, 'aya:', _offset()+1

        activity.query
          sura_id: suraId
          offset: _offset()
          limit: 20
        , (resource, headers) ->
          resource.forEach (res) ->
            unless _.contains ayas.ids, res.id
              ayas.result.push res
              ayas.ids.push res.id

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

    fetch: fetch
    reset: reset
    ayas: ayas
    activity: activity
  ]