/*jshint node: true */

'use strict';

// ## 1. Multiples of 3 and 5
//
// If we list all the natural numbers below 10 that are multiples of 3 or 5,
// we get 3, 5, 6 and 9. The sum of these multiples is 23.
//
// Find the sum of all the multiples of 3 or 5 below 1000.

function triangleNumber(i) {
  return i * (i + 1) / 2;
}

function sumOfMultiplesOf3And5Below(limit) {
  // Approach 2: O(1): use triangle number formula: f(3) = 1 + 2 + 3
  let inclusiveLimit = limit - 1;
  let sum3 = 3 * triangleNumber(inclusiveLimit / 3);
  let sum5 = 5 * triangleNumber(inclusiveLimit / 5);
  let product = 3 * 5;
  let intersection = product * triangleNumber(inclusiveLimit / product);
  return parseInt(sum3 + sum5 - intersection);
}

console.assert(sumOfMultiplesOf3And5Below(10) == (3 + 5 + 6 + 9));
//console.log(sumOfMultiplesOf3And5Below(1000));
