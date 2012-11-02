
/*global define
*/


(function() {

  define(['lodash', 'libs/angular', 'libs/backbone', 'services/services', 'services/message', 'quranutils', 'qurandata'], function(_, angular, Backbone, services) {
    'use strict';
    return services.factory('quran', [
      '$resource', 'message', function($resource, message) {
        var data, i, infoName, infoVal, j, key, mapping, newKey, oldKey, quran, val, _i, _j, _len, _len1, _ref, _ref1, _tname;
        quran = {
          markings: {
            Pause: ["\u06D6", "\u06D7", "\u06D8", "\u06D9", "\u06DA", "\u06DB"],
            Vowel: ["\u064B", "\u064C", "\u064D", "\u064E", "\u064F", "\u0650", "\u0651", "\u0652", "\u0653", "\u0654", "\u0655", "\u0656", "\u0657", "\u0658", "\u0659", "\u065A", "\u065B", "\u065C", "\u065D", "\u065E"],
            Sajda: "\u06E9"
          }
        };
        mapping = {
          Sura: {
            name: 'suras',
            keys: ['start', 'ayas', 'order', 'rukus', 'name', 'tname', 'ename', 'type']
          },
          Juz: {
            name: 'juzs',
            keys: ['sura', 'aya']
          },
          HizbQuarter: {
            name: 'hizbs',
            keys: ['sura', 'aya']
          },
          Manzil: {
            name: 'manzils',
            keys: ['sura', 'aya']
          },
          Ruku: {
            name: 'rukus',
            keys: ['sura', 'aya']
          },
          Page: {
            name: 'pages',
            keys: ['sura', 'aya']
          },
          Sajda: {
            name: 'sajdas',
            keys: ['sura', 'aya', 'hukm']
          }
        };
        for (infoName in mapping) {
          infoVal = mapping[infoName];
          oldKey = infoName;
          newKey = infoVal.name;
          quran[newKey] = new Backbone.Collection;
          i = 0;
          _ref = QuranData[oldKey];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            val = _ref[_i];
            data = {
              id: (i++) + 1
            };
            _ref1 = infoVal.keys;
            for (j = _j = 0, _len1 = _ref1.length; _j < _len1; j = ++_j) {
              key = _ref1[j];
              data[key] = val[j];
            }
            quran[newKey].push(data);
          }
        }
        _tname = function(id) {
          if (quran.suras.get(id)) {
            return quran.suras.get(id).get('tname');
          } else {
            return false;
          }
        };
        quran.suras.each(function(sura) {
          return sura.set({
            permalink: _.suraPermalink(sura.id),
            next_link: _.suraPermalink(sura.id + 1),
            prev_link: _.suraPermalink(sura.id - 1),
            next_title: _tname(sura.id + 1),
            prev_title: _tname(sura.id - 1)
          });
        });
        window.quran = quran;
        return window.quran;
      }
    ]);
  });

}).call(this);
