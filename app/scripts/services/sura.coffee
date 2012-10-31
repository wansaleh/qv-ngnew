###global define###

define [
  'lodash'
  'libs/angular'
  'libs/backbone'
  'services/services'
  'services/message'
  'services/quran'
  'libs/angular-resource'
],

(_, angular, Backbone, services) ->
  'use strict'

  services.factory 'sura',
  ['$http', '$resource', 'message', 'quran',
  ($http, $resource, message, quran) ->

    class Ayas extends Backbone.Collection
      url: '/api/ayas.json'
      comparator: (aya) -> aya.get 'aya'

    ayas =
      result: []
      collection: new Ayas

    ayas.collection.on 'reset', (res) ->
      ayas.result = res.toJSON()
    ayas.collection.on 'add', (res) ->
      ayas.result.push res.toJSON()

    activity = $resource '/api/ayas.json'

    # aya information
    ayaInfo = (ayas) ->
      for aya in ayas
        _.extend aya,
          juz: do ->
            juz = _.first quran.juzs.where(sura: aya.sura_id, aya: aya.aya)
            if juz? then juz.id else false

          hizb: do ->
            hizb = _.first quran.hizbs.where(sura: aya.sura_id, aya: aya.aya)
            if hizb? then hizb.id else false

          ruku: do ->
            ruku = _.first quran.rukus.where(sura: aya.sura_id, aya: aya.aya)
            if ruku? then ruku.id else false

          manzil: do ->
            manzil = _.first quran.manzils.where(sura: aya.sura_id, aya: aya.aya)
            if manzil? then manzil.id else false

          sajda: do ->
            sajda = _.first quran.sajdas.where(sura: aya.sura_id, aya: aya.aya)
            if !sajda then 0 else switch sajda.get('hukm')
              when 'recommended' then 1
              when 'obligatory'  then 2



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
          ayas.collection.add(ayaInfo resource)

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
      ayas.collection.reset()

    fetch: fetch
    reset: reset
    ayas: ayas
    activity: activity
  ]