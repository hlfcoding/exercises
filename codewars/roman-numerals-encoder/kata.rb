TranslationTable = {
  M: [1, 3],
  D: [5, 2],
  C: [1, 2],
  L: [5, 1],
  X: [1, 1],
  V: [5, 0],
  I: [1, 0],
}

def _letter(digit, power)
  TranslationTable.key([digit, power]).to_s
end

def _letters(d, p)
  return '' if d == 0
  l = _letter(d, p)
  return l unless l.empty?
  l1, l5, l1n = [_letter(1, p), _letter(5, p), _letter(1, p + 1)]
  return l1 + (d == 9 ? l1n : l5) if [4, 9].include?(d)
  ls = (d >= 5 && d -= 5) ? l5 : ''
  d.downto(1) { ls << l1 }
  ls
end

def solution(number)
  a = number.to_s.split //
  a.map.with_index { |d, i| [d.to_i, a.count - 1 - i] }
   .reduce('') { |m, (d, p)| m + _letters(d, p) }
end

require_relative '../test.rb'

Test.expect solution(1000) == 'M', '1000 should == "M"'
Test.expect solution(4) == 'IV', '4 should == "IV"'
Test.expect solution(1) == 'I', '1 should == "I"'
Test.expect solution(1990) == 'MCMXC', '1990 should == "MCMXC"'
Test.expect solution(2008) == 'MMVIII', '2008 should == "MMVIII"'
