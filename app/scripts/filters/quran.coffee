define ['filters/filters', 'quranutils', 'utils', 'lodash'],
(filters, qu, utils, _) ->
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

  filters.filter 'suraValid', ->
    (suraId) -> qu.suraValid suraId

  filters.filter 'permalink', ->
    (sura) -> qu.suraPermalink(sura.id)

  filters.filter 'nextlink', ->
    (sura) -> qu.suraPermalink(sura.id + 1)

  filters.filter 'prevlink', ->
    (sura) -> qu.suraPermalink(sura.id - 1)

  filters.filter 'ayatext', ->
    (aya) -> qu.ayaText(aya)

  filters.filter 'ayaimg', ->
    (aya) -> qu.ayaImg(aya)

  # helpers
  filters.filter 'arab', ->
    (num) -> qu.arab num

  filters.filter 'pad', ->
    (input, length = 3, padstr = '0') -> _.lpad input, length, padstr

  filters.filter 'ordinal', ->
    (num) -> qu.ordinal num

  filters.filter 'truncate', ->
    (string, length) -> _.prune string, length

  filters.filter 'highlight', ->
    (string, highlightString) ->
      return unless highlightString?
      _.str(string).replace(new RegExp(highlightString, 'g'), "<span class='highlight'>#{highlightString}</span>")
