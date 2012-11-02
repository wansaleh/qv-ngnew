
/*global define
*/


(function() {

  define(['libs/angular', 'jquery', 'lodash', 'underscore.string', 'utils', 'quranutils', 'libs/angular-resource', 'libs/angular-ui', 'controllers/controllers', 'directives/directives', 'filters/filters', 'responseInterceptors/responseInterceptors', 'services/services'], function(angular) {
    'use strict';
    return angular.module('app', ['ui', 'controllers', 'directives', 'filters', 'ngResource', 'responseInterceptors', 'services']);
  });

}).call(this);
