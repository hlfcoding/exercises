module.exports = {
  expect(expression, message) {
    console.assert(...arguments);
    if (!!expression) {
      console.log('PASS', message);
    }
  }
};
