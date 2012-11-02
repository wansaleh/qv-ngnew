define ['lodash', 'utils'],
(_) ->

  # Arabic numbers, 1-9
  arabicNums = ["\u0660", "\u0661", "\u0662", "\u0663", "\u0664", "\u0665", "\u0666", "\u0667", "\u0668", "\u0669"]

  utils =
    # Check validity of sura id
    suraValid: (id) -> 1 <= id <= 114

    # generate permalink of sura
    suraPermalink: (id) ->
      return false unless @suraValid id
      "/sura/#{id}"

    # translate number to arabic.
    arab: (number) ->
      _.to_s(number).replace /[0-9]/g, (w) -> arabicNums[+w]

    # Append suffixes to numbers.
    ordinal: (number) ->
      number = _.to_i number
      n = number % 100;
      suffix = _.words 'th st nd rd th'
      ord = if n < 21 then (if n < 4 then suffix[n] else suffix[0]) else (if n % 10 > 4 then suffix[0] else suffix[n % 10])
      number + ord

  _.mixin utils

  utils