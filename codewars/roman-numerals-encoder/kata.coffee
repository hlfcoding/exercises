_translationTable =
  M: [1, 3]
  D: [5, 2]
  C: [1, 2]
  L: [5, 1]
  X: [1, 1]
  V: [5, 0]
  I: [1, 0]

_getLetter = (digit, power) ->
  for letter, v of _translationTable
    [d, p] = v
    return letter if d is digit and p is power

_getInt = (letter) ->
  [digit, power] = _translationTable[letter]
  digit * Math.pow(10, power)

solution = (int) ->
  digits = "#{int}".split ''
  str = ''
  for d, i in digits when d isnt '0'
    p = (digits.length - 1) - i
    d = parseInt d
    l = _getLetter d, p
    if l? then str += l
    else
      if d in [4, 9]
        str += _getLetter 1, p
        str += if d is 9 then _getLetter(1, ++p) else _getLetter(5, p)
      else
        if d >= 5
          str += _getLetter 5, p
          d -= 5
        until d is 0
          str += _getLetter 1, p
          d -= 1
  str

Test =
  expect: (expression, message) ->
    console.assert arguments...
    if !!expression
      console.log 'PASS', message

Test.expect(solution(1000) == 'M', '1000 should == "M"')
Test.expect(solution(4) == 'IV', '4 should == "IV"')
Test.expect(solution(1) == 'I', '1 should == "I"')
Test.expect(solution(1990) == 'MCMXC', '1990 should == "MCMXC"')
Test.expect(solution(2008) == 'MMVIII', '2008 should == "MMVIII"')
