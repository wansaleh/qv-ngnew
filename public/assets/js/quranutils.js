(function() {

  define(['lodash', 'utils'], function(_) {
    var arabicNums, utils;
    arabicNums = ["\u0660", "\u0661", "\u0662", "\u0663", "\u0664", "\u0665", "\u0666", "\u0667", "\u0668", "\u0669"];
    utils = {
      suraValid: function(id) {
        return (1 <= id && id <= 114);
      },
      suraPermalink: function(id) {
        if (!this.suraValid(id)) {
          return false;
        }
        return "/sura/" + id;
      },
      ayaText: function(aya) {
        var text;
        text = aya.sura_id !== 1 && aya.aya === 1 ? aya.text.slice(39) : aya.text;
        return text.replace(/[\s\n]+/g, ' ');
      },
      ayaImg: function(aya) {
        return "/assets/img/ayas/" + aya.sura_id + "_" + aya.aya + ".png";
      },
      arab: function(number) {
        return _.to_s(number).replace(/[0-9]/g, function(w) {
          return arabicNums[+w];
        });
      },
      ordinal: function(number) {
        var n, ord, suffix;
        number = _.to_i(number);
        n = number % 100;
        suffix = _.words('th st nd rd th');
        ord = n < 21 ? (n < 4 ? suffix[n] : suffix[0]) : (n % 10 > 4 ? suffix[0] : suffix[n % 10]);
        return number + ord;
      }
    };
    return utils;
  });

}).call(this);
