###global define###

define [
  'libs/angular'
  'services/services'
  'services/message'
  'utils'
  'qurandata'
],

(angular, services, message) ->
  'use strict'

  services.factory 'quran', ['$resource', 'message', ($resource, message) ->

    # Check validity of sura id
    valid = (id) -> 1 <= id <= 114

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
      quran[newKey] = []
      i = 0

      for val in QuranData[oldKey]
        data = id: (i++) + 1
        data[key] = val[j] for key, j in infoVal.keys

        data.get = (attr) ->
          return false if _.isUndefined this[attr]
          this[attr]

        quran[newKey].push data

      # get helper
      quran[newKey].get = (id) ->
        id = _.to_i id
        return false if not valid id
        _.find this, (sura) -> sura.id == id

    # Expose for convenience
    window.quran = quran
    window.quran
  ]