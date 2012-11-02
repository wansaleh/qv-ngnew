
/*global define
*/


(function() {

  define(['filters/filters', 'quranutils', 'utils', 'lodash'], function(filters, qu, utils, _) {
    'use strict';
    filters.filter('l', [
      'html5', function(html5) {
        return function(link) {
          link = link.replace(/^\/?#\/?/, '');
          if (!html5) {
            link = "/#/" + link;
          }
          return link;
        };
      }
    ]);
    filters.filter('not', function() {
      return function(value) {
        return !!!value;
      };
    });
    filters.filter('suraValid', function() {
      return function(suraId) {
        return qu.suraValid(suraId);
      };
    });
    filters.filter('permalink', function() {
      return function(sura) {
        return qu.suraPermalink(sura.id);
      };
    });
    filters.filter('nextlink', function() {
      return function(sura) {
        return qu.suraPermalink(sura.id + 1);
      };
    });
    filters.filter('prevlink', function() {
      return function(sura) {
        return qu.suraPermalink(sura.id - 1);
      };
    });
    filters.filter('ayatext', function() {
      return function(aya) {
        return qu.ayaText(aya);
      };
    });
    filters.filter('ayaimg', function() {
      return function(aya) {
        return qu.ayaImg(aya);
      };
    });
    filters.filter('arab', function() {
      return function(num) {
        return qu.arab(num);
      };
    });
    filters.filter('pad', function() {
      return function(input, length, padstr) {
        if (length == null) {
          length = 3;
        }
        if (padstr == null) {
          padstr = '0';
        }
        return _.lpad(input, length, padstr);
      };
    });
    filters.filter('ordinal', function() {
      return function(num) {
        return qu.ordinal(num);
      };
    });
    return filters.filter('truncate', function() {
      return function(string, length) {
        return _.prune(string, length);
      };
    });
  });

}).call(this);
