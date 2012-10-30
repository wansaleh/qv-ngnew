
/*global define
*/


(function() {

  define(['directives/directives'], function(directives) {
    'use strict';

    var msie;
    msie = parseInt((/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1], 10);
    return directives.directive('myHref', [
      'html5', function(html5) {
        return {
          priority: 99,
          link: function(scope, element, attr) {
            return attr.$observe('myHref', function(value) {
              if (!value) {
                return;
              }
              value = (html5 ? '/' : '/#/') + value.replace(/^\/+/, '');
              attr.$set('href', value);
              if (msie) {
                return element.prop('href', value);
              }
            });
          }
        };
      }
    ]);
  });

}).call(this);
