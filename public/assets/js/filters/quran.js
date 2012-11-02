
/*global define
*/


(function() {

  define(['filters/filters', 'services/quran', 'quranutils'], function(filters) {
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
        return _.suraValid(suraId);
      };
    });
    filters.filter('permalink', function() {
      return function(sura) {
        return _.suraPermalink(sura.id);
      };
    });
    filters.filter('nextlink', function() {
      return function(sura) {
        return _.suraPermalink(sura.id + 1);
      };
    });
    filters.filter('prevlink', function() {
      return function(sura) {
        return _.suraPermalink(sura.id - 1);
      };
    });
    filters.filter('ayatext', function() {
      return function(aya) {
        if (aya.sura_id !== 1 && aya.aya === 1) {
          return aya.text.slice(39);
        } else {
          return aya.text;
        }
      };
    });
    filters.filter('ayaimg', function() {
      return function(aya) {
        return "/assets/img/ayas/" + aya.sura_id + "_" + aya.aya + ".png";
      };
    });
    filters.filter('juz', function() {
      return function(aya) {
        var juz;
        juz = _.first(quran.juzs.where({
          sura: aya.sura_id,
          aya: aya.aya
        }));
        if (juz != null) {
          return juz.get('id');
        } else {
          return false;
        }
      };
    });
    filters.filter('arab', function() {
      return function(num) {
        return _.arab(num);
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
        return _.ordinal(num);
      };
    });
    return filters.filter('truncate', function() {
      return function(string, length) {
        return _.prune(string, length);
      };
    });
  });

}).call(this);
