define [
  'lodash'
  'libs/angular'
  'libs/backbone'
  'quranutils'
  'services/services'
  'services/message'
  'services/quran'
],

(_, angular, Backbone, qu, services) ->
  'use strict'

  services.factory 'sura',
  ['$http', '$resource', 'message', 'quran',
  ($http, $resource, message, quran) ->

    Ayas = Backbone.Collection.extend
      url: '/api/ayas.json'
      comparator: (aya) -> aya.get 'aya'

    ayas =
      result: []
      collection: new Ayas
      loaded: 0

    ayas.collection.on 'reset', (res) ->
      ayas.result = res.toJSON()
    ayas.collection.on 'add', (res) ->
      ayas.result.push res.toJSON()

    activity = $resource '/api/ayas.json'

    # aya information
    ayaInfo = (ayas) ->
      for aya in ayas
        _.extend aya,
          ayatext: qu.ayaText(aya)
          juz: quran.juzs.whereFirst(sura: aya.sura_id, aya: aya.aya)
          hizb: quran.hizbs.whereFirst(sura: aya.sura_id, aya: aya.aya)
          ruku: quran.rukus.whereFirst(sura: aya.sura_id, aya: aya.aya)
          manzil: quran.manzils.whereFirst(sura: aya.sura_id, aya: aya.aya)
          sajda: do ->
            sajda = quran.sajdas.whereFirst(sura: aya.sura_id, aya: aya.aya)
            if !sajda then 0 else switch sajda.get('hukm')
              when 'recommended' then 1
              when 'obligatory'  then 2

    fetch = (suraId, ayaId, success = angular.noop) ->
      $win = $(window)
      $doc = $(document)

      console.group 'sura service - sura:', suraId

      # stop scroll event
      $win.off 'scroll', _lazyloader

      suraInfo = quran.suras.get(suraId)

      _offset = ->
        if last = ayas.collection.last() then last.get('aya') else 0

      _limit = ->
        limit = 20
        ayaId = _.int ayaId
        limit = limit * Math.ceil(ayaId/limit) if ayaId?
        limit

      _query = ->
        console.log 'start sura:', suraId, 'aya offset:', _offset()+1

        activity.query
          sura_id: suraId
          offset: _offset()
          limit: _limit()
        , (resource, headers) ->
          # append in collection
          ayas.collection.add(ayaInfo resource)

          # set loaded counter
          ayas.loaded = ayas.collection.length

          # attach scroll event
          $win.on 'scroll', _lazyloader
          success()

          _.defer ->
            if ayaId?
              $("#aya-#{ayaId}").stop().scrollTo(offset: -100, duration: 0)


      _lazyloader = _.throttle ->
        _query() if $win.scrollTop() > $doc.height() - 2*$win.height() and
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
  ]