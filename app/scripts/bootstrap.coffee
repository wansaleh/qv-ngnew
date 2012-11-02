###global define###

define ['jquery', 'require', 'libs/angular', 'app'], ($, require, angular) ->
  'use strict'

  $ ->
    angular.bootstrap document, ['app']

    $('.page-header').live 'click', ->
      if $(window).scrollTop() > 100
        $('body').stop().scrollTo()