
/*global define
*/


(function() {

  define(['jquery', 'require', 'libs/angular', 'app'], function($, require, angular) {
    'use strict';
    return $(function() {
      angular.bootstrap(document, ['app']);
      return $('.page-header').live('click', function() {
        if ($(window).scrollTop() > 100) {
          return $('body').stop().scrollTo();
        }
      });
    });
  });

}).call(this);
