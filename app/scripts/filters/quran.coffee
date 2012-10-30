###global define###

define ['filters/filters', 'services/helpers', 'services/quran', 'utils'], (filters) ->
  'use strict'

  # filter definitions

  # link prefix helper
  filters.filter 'l', ['html5', (html5) ->
    (link) ->
      link = link.replace /^\/?#\/?/, ''
      link = "/#/#{link}" unless html5
      link
  ]

  filters.filter 'not', ->
    (value) -> !!!value

  filters.filter 'suraValid', ['helpers', (helpers) ->
    (suraId) -> helpers.suraValid suraId
  ]

  filters.filter 'permalink', ['helpers', (helpers) ->
    (sura) -> helpers.suraPermalink(sura.id)
  ]

  filters.filter 'nextlink', ['helpers', (helpers) ->
    (sura) -> helpers.suraPermalink(sura.id + 1)
  ]

  filters.filter 'prevlink', ['helpers', (helpers) ->
    (sura) -> helpers.suraPermalink(sura.id - 1)
  ]

  filters.filter 'ayatext', ->
    (aya) ->
      if aya.sura_id != 1 and aya.aya == 1 then aya.text.slice(39) else aya.text

  filters.filter 'ayaimg', ->
    (aya) ->
      "/assets/img/ayas/#{aya.sura_id}_#{aya.aya}.png"

  filters.filter 'juz', ->
    (aya) ->
      juz = _.first quran.juzs.where(sura: aya.sura_id, aya: aya.aya)
      if juz? then juz.get('id') else false

  # helpers
  filters.filter 'arab', ->
    (num) -> _.arab num

  filters.filter 'pad', ->
    (input, length = 3, padstr = '0') ->
      _.lpad input, length, padstr

  filters.filter 'ordinal', ->
    (num) -> _.ordinal num

  filters.filter 'truncate', ->
    (string, length) -> _.prune string, length

  filters.filter 'highlight', ->
    (text, filter) ->
      if !filter
        text
      else
        text.replace(new RegExp(filter, 'gi'), '<span class="match">$&</span>')
