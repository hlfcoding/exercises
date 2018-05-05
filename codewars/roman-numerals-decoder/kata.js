function solution(roman) {
  const map = { M: 1000, D: 500, C: 100, L: 50, X: 10, V: 5, I: 1 };
  let n = 0;
  for (let dp, ls = roman.split(''), i = ls.length; i--;) {
    let l = ls[i], d = map[l];
    n += d * (d < dp && dp != null ? -1 : 1);
    dp = d;
  }
  return n;
}

const Test = require('../test');

Test.expect(solution('XXI') == 21, 'XXI should == 21');
Test.expect(solution('I') == 1, 'I should == 1');
Test.expect(solution('IV') == 4, 'IV should == 4');
Test.expect(solution('MMVIII') == 2008, 'MMVIII should == 2008');
Test.expect(solution('MDCLXVI') == 1666, 'MDCLXVI should == 1666');
