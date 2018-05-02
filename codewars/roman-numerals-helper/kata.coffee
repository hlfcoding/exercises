RomanNumerals =

  _translationTable:
    M: [1, 3]
    D: [5, 2]
    C: [1, 2]
    L: [5, 1]
    X: [1, 1]
    V: [5, 0]
    I: [1, 0]

  _getLetter: (digit, power) ->
    for letter, [d, p] of @_translationTable
      return letter if d is digit and p is power

  _getInt: (letter) ->
    [digit, power] = @_translationTable[letter]
    digit * Math.pow(10, power)

  toRoman: (int) ->
    "#{int}".split ''
    .map (d, i, a) -> [parseInt(d), a.length - 1 - i]
    .reduce (r, [d, p]) =>
      return r if d is 0
      l = @_getLetter d, p
      return r + l if l?
      [l1, l5, l1n] = [@_getLetter(1, p), @_getLetter(5, p), @_getLetter(1, p + 1)]
      return r + l1 + (if d is 9 then l1n else l5) if d in [4, 9]
      r += l5 if d >= 5 and d -= 5
      r += l1 while d--
      return r
    , ''

  fromRoman: (str) ->
    letters = str.split ''
    int = 0
    for l, i in letters
      n = @_getInt l
      lNext = letters[i + 1] if i < letters.length
      dir = 1
      if lNext?
        nNext = @_getInt lNext
        dir = -1 if nNext > n
      int += dir * n
    int

Test = require '../test'

Test.expect(RomanNumerals.toRoman(1000) == 'M', '1000 should == "M"')
Test.expect(RomanNumerals.toRoman(4) == 'IV', '4 should == "IV"')
Test.expect(RomanNumerals.toRoman(1) == 'I', '1 should == "I"')
Test.expect(RomanNumerals.toRoman(1990) == 'MCMXC', '1990 should == "MCMXC"')
Test.expect(RomanNumerals.toRoman(2008) == 'MMVIII', '2008 should == "MMVIII"')

Test.expect(RomanNumerals.fromRoman('XXI') == 21, 'XXI should == 21')
Test.expect(RomanNumerals.fromRoman('I') == 1, 'I should == 1')
Test.expect(RomanNumerals.fromRoman('IV') == 4, 'IV should == 4')
Test.expect(RomanNumerals.fromRoman('MMVIII') == 2008, 'MMVIII should == 2008')
Test.expect(RomanNumerals.fromRoman('MDCLXVI') == 1666, 'MDCLXVI should == 1666')
