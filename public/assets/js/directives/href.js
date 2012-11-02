
/*global define
*/


(function() {

  define(['lodash', 'utils', 'directives/directives'], function(_, utils, directives) {
    'use strict';

    var msie;
    msie = _.to_i((/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1]);
    directives.directive('qvHref', [
      'html5', function(html5) {
        return {
          priority: 99,
          link: function(scope, element, attr) {
            return attr.$observe('qvHref', function(value) {
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
    return directives.directive('qvTitle', function() {
      return {
        priority: 99,
        link: function(scope, element, attr) {
          return attr.$observe('qvTitle', function(value) {
            if (!value) {
              return;
            }
            attr.$set('title', value);
            if (msie) {
              return element.prop('title', value);
            }
          });
        }
      };
    });
  });

}).call(this);
