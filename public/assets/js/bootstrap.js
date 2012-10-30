
/*global define
*/


(function() {

  define(['require', 'libs/angular', 'app'], function(require, angular) {
    'use strict';
    return require(['libs/domReady!'], function(document) {
      return angular.bootstrap(document, ['app']);
    });
  });

}).call(this);
