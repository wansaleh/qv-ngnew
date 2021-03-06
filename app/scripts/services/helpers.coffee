define [
  'libs/angular'
  'services/services'
  'services/message'
  'libs/angular-resource'
],

(angular, services) ->
  'use strict'

  services.factory 'helpers',
  ['$resource', 'message'
  ($resource, message) ->

    # Check validity of sura id
    suraValid = (id) -> 1 <= id <= 114

    # generate permalink of sura
    suraPermalink = (id) ->
      return false unless suraValid id
      "/sura/#{id}"

    suraValid:     suraValid
    suraPermalink: suraPermalink
  ]