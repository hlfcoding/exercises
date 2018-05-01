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
    for letter, v of @_translationTable
      [d, p] = v
      return letter if d is digit and p is power

  _getInt: (letter) ->
    [digit, power] = @_translationTable[letter]
    digit * Math.pow(10, power)

  toRoman: (int) ->
    digits = "#{int}".split ''
    str = ''
    for d, i in digits when d isnt '0'
      p = (digits.length - 1) - i
      d = parseInt d
      l = @_getLetter d, p
      if l? then str += l
      else
        if d in [4, 9]
          str += @_getLetter 1, p
          str += if d is 9 then @_getLetter(1, ++p) else @_getLetter(5, p)
        else
          if d >= 5
            str += @_getLetter 5, p
            d -= 5
          until d is 0
            str += @_getLetter 1, p
            d -= 1
    str

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
