###global define###

define [
  'lodash'
  'libs/angular'
  'libs/backbone'
  'quranutils'
  'services/services'
  'qurandata'
],

(_, angular, Backbone, qu, services) ->
  'use strict'

  # cleanup vendor datafile
  quran =
    markings:
      Pause: ["\u06D6", "\u06D7", "\u06D8", "\u06D9", "\u06DA", "\u06DB"]
      Vowel: ["\u064B", "\u064C", "\u064D", "\u064E", "\u064F", "\u0650", "\u0651",
              "\u0652", "\u0653", "\u0654", "\u0655", "\u0656", "\u0657", "\u0658",
              "\u0659", "\u065A", "\u065B", "\u065C", "\u065D", "\u065E"]
      Sajda:  "\u06E9"

  mapping =
    Sura:        {name: 'suras',   keys: ['start', 'ayas', 'order', 'rukus', 'name', 'tname', 'ename', 'type']}
    Juz:         {name: 'juzs',    keys: ['sura', 'aya']}
    HizbQuarter: {name: 'hizbs',   keys: ['sura', 'aya']}
    Manzil:      {name: 'manzils', keys: ['sura', 'aya']}
    Ruku:        {name: 'rukus',   keys: ['sura', 'aya']}
    Page:        {name: 'pages',   keys: ['sura', 'aya']}
    Sajda:       {name: 'sajdas',  keys: ['sura', 'aya', 'hukm']}

  for infoName, infoVal of mapping
    oldKey = infoName
    newKey = infoVal.name
    quran[newKey] = new Backbone.Collection
    i = 0

    for val in QuranData[oldKey]
      data = id: (i++) + 1
      data[key] = val[j] for key, j in infoVal.keys
      quran[newKey].push data

  _tname = (id) ->
    if quran.suras.get(id)
      quran.suras.get(id).get('tname')
    else
      false

  quran.suras.each (sura) ->
    sura.set
      permalink: qu.suraPermalink(sura.id)
      next_link: qu.suraPermalink(sura.id + 1)
      prev_link: qu.suraPermalink(sura.id - 1)
      next_title: _tname(sura.id + 1)
      prev_title: _tname(sura.id - 1)

  services.factory 'quran', -> quran

  # Expose for convenience
  # window.quran = quran
  quran