TranslationTable = {
  M: [1, 3],
  D: [5, 2],
  C: [1, 2],
  L: [5, 1],
  X: [1, 1],
  V: [5, 0],
  I: [1, 0],
}

def get_letter(digit, power)
  TranslationTable.key([digit, power]).to_s
end

def get_int(letter)
  digit, power = TranslationTable[letter]
  digit * 10 ** power
end

def solution(number)
  digits = number.to_s.split ''
  str = ''
  digits
    .each_with_index do |d, i|
      p = (digits.length - 1) - i
      d = d.to_i
      l = get_letter d, p
      if l.empty?
        if [4, 9].include? d
          str.concat get_letter 1, p
          str.concat d == 9 ? get_letter(1, p + 1) : get_letter(5, p)
        else
          if d >= 5
            str.concat get_letter 5, p
            d -= 5
          end
          until d == 0
            str.concat get_letter 1, p
            d -= 1
          end
        end
      else str.concat l
      end
    end
  # puts str
  str
end

require_relative '../test.rb'

Test.expect solution(1000) == 'M', '1000 should == "M"'
Test.expect solution(4) == 'IV', '4 should == "IV"'
Test.expect solution(1) == 'I', '1 should == "I"'
Test.expect solution(1990) == 'MCMXC', '1990 should == "MCMXC"'
Test.expect solution(2008) == 'MMVIII', '2008 should == "MMVIII"'
