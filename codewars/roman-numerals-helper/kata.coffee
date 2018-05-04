RomanNumerals =

  _translationTable:
    M: [1, 3]
    D: [5, 2]
    C: [1, 2]
    L: [5, 1]
    X: [1, 1]
    V: [5, 0]
    I: [1, 0]

  _int: (letter) ->
    [digit, power] = @_translationTable[letter]
    digit * Math.pow(10, power)

  _letter: (digit, power) ->
    for l, [d, p] of @_translationTable
      return l if d is digit and p is power

  _letters: (d, p) ->
    return '' if d is 0
    return l if l = @_letter(d, p)
    [l1, l5, l1n] = [@_letter(1, p), @_letter(5, p), @_letter(1, p + 1)]
    return l1 + (if d is 9 then l1n else l5) if d in [4, 9]
    ls = if d >= 5 and d -= 5 then l5 else ''
    ls += l1 while d--
    ls

  fromRoman: (str) ->
    str.split ''
    .map (l, i, a) => [l, a[i + 1], @_int(l)]
    .reduce (m, [l, ln, n]) =>
      m + n * (if ln? and @_int(ln) > n then -1 else 1)
    , 0

  toRoman: (int) ->
    "#{int}".split ''
    .map (d, i, a) -> [parseInt(d), a.length - 1 - i]
    .reduce (m, [d, p]) =>
      m + @_letters(d, p)
    , ''

Test = require '../test'

Test.expect(RomanNumerals.fromRoman('XXI') == 21, 'XXI should == 21')
Test.expect(RomanNumerals.fromRoman('I') == 1, 'I should == 1')
Test.expect(RomanNumerals.fromRoman('IV') == 4, 'IV should == 4')
Test.expect(RomanNumerals.fromRoman('MMVIII') == 2008, 'MMVIII should == 2008')
Test.expect(RomanNumerals.fromRoman('MDCLXVI') == 1666, 'MDCLXVI should == 1666')

Test.expect(RomanNumerals.toRoman(1000) == 'M', '1000 should == "M"')
Test.expect(RomanNumerals.toRoman(4) == 'IV', '4 should == "IV"')
Test.expect(RomanNumerals.toRoman(1) == 'I', '1 should == "I"')
Test.expect(RomanNumerals.toRoman(1990) == 'MCMXC', '1990 should == "MCMXC"')
Test.expect(RomanNumerals.toRoman(2008) == 'MMVIII', '2008 should == "MMVIII"')
