//: # Project Euler
//:
import Foundation
//:
//: ## 1. Multiples of 3 and 5
//:
//: If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
//:
//: Find the sum of all the multiples of 3 or 5 below 1000.
//:
extension Int {
    func triangleNumber() -> Int {
        return self * (self + 1) / 2
    }
}

func sumOfMultiplesOf3And5Below(limit: Int) -> Int {
    // Approach 1: O(n): brute force
    /*
    var sum = 0
    for n in 3..<limit where n % 3 == 0 || n % 5 == 0 {
        sum += n
    }
    return sum
    */
    // Approach 2: O(1): use triangle number formula: f(3) = 1 + 2 + 3
    let inclusiveLimit = limit - 1
    let sum3 = 3 * (inclusiveLimit / 3).triangleNumber()
    let sum5 = 5 * (inclusiveLimit / 5).triangleNumber()
    let product = 3 * 5
    let intersection = product * (inclusiveLimit / product).triangleNumber()
    return sum3 + sum5 - intersection
}

assert(sumOfMultiplesOf3And5Below(10) == (3 + 5 + 6 + 9))
//sumOfMultiplesOf3And5Below(1000)
//:
//: ## 2. Even Fibonacci numbers
//:
//: Each new term in the Fibonacci sequence is generated by adding the previous two terms. By starting with 1 and 2, the first 10 terms will be:
//:
//: 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
//:
//: By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.
//:
func sumOfEvenFibonaccis(limit: Int = 4000000) -> Int {
    var sum = 2
    var n1 = 1
    var n2 = 2
    while n1 + n2 < limit {
        let temp = n1
        n1 = n2
        n2 = temp + n2
        if n2 % 2 == 0 {
            sum += n2
        }
    }
    print("Largest fib within limit is \(n2)")
    return sum
}

//sumOfEvenFibonaccis()
//:
//: ## 3. Largest prime factor
//:
//: The prime factors of 13195 are 5, 7, 13 and 29.
//:
//: What is the largest prime factor of the number 600851475143 ?
//:
//: > A prime number (or a prime) is a natural number greater than 1 that has no positive divisors other than 1 and itself. A natural number greater than 1 that is not a prime number is called a composite number.
//:
var primes = Set<Int>()

extension Int {
    func isPrime() -> Bool {
        if primes.contains(self) {
            return true
        }
        var isPrime = true
        var divisor = 2
        while divisor <= self / divisor {
            isPrime = self % divisor != 0
            if !isPrime { break }
            divisor++
        }
        if isPrime {
            primes.insert(self)
        }
        return isPrime
    }

    func nextPrime() -> Int {
        var candidate = self
        repeat {
            candidate++
        } while !candidate.isPrime()
        return candidate
    }
}

assert(2.isPrime())
assert(3.isPrime())
assert(!4.isPrime())

assert(29.nextPrime() == 31)

extension Int {
    /**
     Try dividing number, starting from smallest prime, 2.
     Keep updating the bounds with each division until bounds <= divisor.
     */
    func largestPrimeFactor() -> Int {
        var prime = 1
        var factor = 1
        var safety = 1000

        while prime < self / prime && safety > 0 {
            safety--
            prime = prime.nextPrime()
            if self % prime == 0 {
                factor = prime
            }
        }
        if safety == 0 {
            print("Being safe and not continuing!")
        }
        
        return factor
    }
}

// Wow.
//600851475143.largestPrimeFactor()
//:
//: ## 4. Largest palindrome product
//:
//: A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
//:
//: Find the largest palindrome made from the product of two 3-digit numbers.
//:
//: ---
//:
//: First solution decreases both factors simultaneously. This approach is faster at finding a palindrome but unlikely to find the largest palindrome.
//:
//: Second solution quadratically checks by running through first n largest possiblities of second factor against each n largest possibilities of first factor.
//:

extension Int {
    func isPalindrome() -> Bool {
        let digits = Array(String(self).characters)
        if digits.count % 2 != 0 { return false }
        return digits.reverse() == digits
    }
}

assert(9009.isPalindrome())
assert(!123.isPalindrome())

func largestPalindromeFromTwoNumbersWithDigits(digits: Int) -> Int {
    guard let n = Int(Array(count: digits, repeatedValue: "9").joinWithSeparator(""))
          else { return 0 }
    var n1 = n
    var n2 = n
    var product = n1 * n2
//    while !isPalindrome(product) && product > 0 {
//        if n1 > n2 { n1-- }
//        else { n2-- }
//        product = n1 * n2
//    }
    repeat {
        n2 = n
        repeat {
            product = n1 * n2
            n2--
        } while !product.isPalindrome() && Double(n2) / Double(n) > 0.9
        n1--
    } while !product.isPalindrome() && Double(n1) / Double(n) > 0.9
    return product
}

//largestPalindromeFromTwoNumbersWithDigits(3)
//:
//: ## 5. Smallest multiple
//:
//: 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
//:
//: What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
//:
//: ---
//:
//: The initial approach is to just have the step be the max factor. This won't scale for the larger range. Instead, the product of the primes in the range seems like a much better step, for reasons yet fully clear. Another optimization is to remove redundancies in the factors before checking divisibility.
//:
extension Int {
    func isDivisibleByNumbers(numbers: [Int]) -> Bool {
        for n in numbers where self % n != 0 {
            return false
        }
        return true
    }
}

assert(4.isDivisibleByNumbers(Array(1...2)))

func smallestMultipleDivisibleByRange(range: Range<Int>) -> Int {
    var factors: [Int] = []
    var step: Int = 1
    outer: for n in range.reverse() {
        if n.isPrime() {
            step *= n
        }
        for f in factors where f > n && f % n == 0 {
            continue outer
        }
        factors.append(n)
    }
    print("Step: \(step), factors: \(factors)")
    var multiple = 0
    repeat {
        multiple += step
    } while !multiple.isDivisibleByNumbers(factors)
    return multiple
}

//smallestMultipleDivisibleByRange(1...10)
//smallestMultipleDivisibleByRange(1...20)
//:
//: ## 6. Sum square difference
//:
//: The sum of the squares of the first ten natural numbers is 1^2 + 2^2 + ... + 10^2 = 385
//:
//: The square of the sum of the first ten natural numbers is (1 + 2 + ... + 10)^2 = 55^2 = 3025
//:
//: Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025 − 385 = 2640.
//:
//: Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
//:
//: ---
//:
//: This problem can simply be brute-forced. The largest number isn't that big, smaller than max 32-bit int.
//:
func pow(n: Int, _ p: Int) -> Int {
    return Int(pow(Double(n), Double(p)))
}

func sumOfSquares(range: Range<Int>) -> Int {
    return range.reduce(0) { $0 + pow($1, 2) }
}

func squareOfSum(range: Range<Int>) -> Int {
    return pow(range.reduce(0) { $0 + $1 }, 2)
}

assert(sumOfSquares(1...10) == 385)
assert(squareOfSum(1...10) == 3025)
assert(squareOfSum(1...10) - sumOfSquares(1...10) == 2640)
//squareOfSum(1...100) - sumOfSquares(1...100)
//:
//: ## 7. 10001st prime
//:
//: By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
//:
//: What is the 10 001st prime number?
//:
//: ---
//:
//: This is the slowest solver yet. Even with the sortedPrimes cache and the notion that primes are found by checking if they're divisible by previous primes, the outerloop runs 100k+ times, so the inner loop and the true operations count is probably much larger. However, the loop didn't seem to slow down very much as the numbers got bigger, so the approach here isn't O(n^2).
//:
//: Also, tick counts and printing are turned off to reduce operations. Any optimization I try to make in the outer loop with slicing sortedPrimes actually makes things run slower, probably due to compiler optimizations.
//:
//: Instead of trial division, the second solution uses a rather unoptimized Sieve of Eratosthenes implementation, which seems to require fewer operations, about half. However, mutating the array while iterating seem to slow things down.
//:
// Given a prime, go through greater numbers and remove multiples.

class SieveOfEratosthenes {
    private let chunkCount = 10000
    private var largestPrimeIndex = 0
    private var upperBound: Int!
    private var nums = [2]

    var lastPrime: Int { return nums[largestPrimeIndex] }
    var primes: [Int] { return Array(nums[0...largestPrimeIndex]) }

    init() {
        upperBound = chunkCount
        nums += 3.stride(through: upperBound, by: 2)
        largestPrimeIndex = 1
    }

    func purgeNextMultiples() {
        purgeMultiplesOfPrime(lastPrime, forNumbers: &nums)
    }

    func purgeMultiplesOfPrime(p: Int, inout forNumbers nums: [Int]) {
        var factor = p // No need to check multiples below the square.
        func multiple() -> Int { return p * factor }
        if multiple() <= nums.first! {
            // Scale factor up as needed (for added chunks).
            factor = nums.first! / multiple()
        }
        while multiple() <= nums.last! {
            if let i = nums.indexOf(multiple()) {
                nums.removeAtIndex(i)
            }
            factor += 2
        }
    }

    func updateCursorIndex() {
        // Update the cursor on where numbers stop being guaranteed primes.
        largestPrimeIndex++
        // If our cursor cannot move forward because our chunk ran out...
        guard largestPrimeIndex == nums.count else { return }
        // Add another chunk.
        let lowerBound = upperBound + 1
        upperBound = upperBound + chunkCount
        var addition = Array(lowerBound.stride(through: upperBound, by: 2))
        for p in nums {
            purgeMultiplesOfPrime(p, forNumbers: &addition)
        }
        nums += addition
    }
}

//var sortedPrimes = [2]
func nthPrime(ordinal: Int) -> Int {
    // Deal with 2 as a special case.
    guard ordinal > 1 else { return 2 }
    let s = SieveOfEratosthenes()
    while (s.largestPrimeIndex + 1) < ordinal {
        s.purgeNextMultiples()
        s.updateCursorIndex()
    }
    return s.lastPrime
    //
    // Solution 1:
    /*
    //var tick = 0
    let prime: Int!
    if ordinal > sortedPrimes.count {
        var candidate = sortedPrimes.last!
        outer: repeat {
            candidate++
            for p in sortedPrimes {
                //tick++
                if candidate % p == 0 {
                    continue outer
                }
            }
            // Is not divisible by previous primes.
            sortedPrimes.append(candidate)
            //print("\(tick): Added \(sortedPrimes.count)th prime: \(candidate)")
        } while sortedPrimes.count < ordinal
        prime = sortedPrimes.last!
    } else {
        prime = sortedPrimes[ordinal - 1]
    }
    return prime
    */
}

//assert(nthPrime(1) == 2)
//assert(nthPrime(6) == 13)
//assert(nthPrime(1000) == 7919)
// Wow.
//nthPrime(10001)
//:
//: ## 8. Largest product in a series
//:
//: The four adjacent digits in the 1000-digit number that have the greatest product are 9 × 9 × 8 × 9 = 5832.
//:
//:     73167176531330624919225119674426574742355349194934
//:     96983520312774506326239578318016984801869478851843
//:     85861560789112949495459501737958331952853208805511
//:     12540698747158523863050715693290963295227443043557
//:     66896648950445244523161731856403098711121722383113
//:     62229893423380308135336276614282806444486645238749
//:     30358907296290491560440772390713810515859307960866
//:     70172427121883998797908792274921901699720888093776
//:     65727333001053367881220235421809751254540594752243
//:     52584907711670556013604839586446706324415722155397
//:     53697817977846174064955149290862569321978468622482
//:     83972241375657056057490261407972968652414535100474
//:     82166370484403199890008895243450658541227588666881
//:     16427171479924442928230863465674813919123162824586
//:     17866458359124566529476545682848912883142607690042
//:     24219022671055626321111109370544217506941658960408
//:     07198403850962455444362981230987879927244284909188
//:     84580156166097919133875499200524063689912560717606
//:     05886116467109405077541002256983155200055935729725
//:     71636269561882670428252483600823257530420752963450
//:
//: Find the thirteen adjacent digits in the 1000-digit number that have the greatest product. What is the value of this product?
//:
//: ---
//:
//: Iterate the array, keeping track of the current range of adjacents. When range fills up, calculate the product. Update max with the product if needed. Upon hitting a zero or whatever's not above the minimum factor, the range gets cleared for next iteration. This approach should be O(n).
//:
func maxAdjacentDigitsProductOfLength(length: Int, digits: [Int], minimumFactor: Int = 1) -> Int {
    var product = 0
    var range: Range<Int>?
    for (i, d) in digits.enumerate() {
        guard d > minimumFactor else {
            range = nil; continue
        }
        guard range != nil else {
            range = Range(start: i, end: i); continue
        }

        range!.endIndex = i + 1 // Shift (non-inclusive) upper bound.

        guard (range!.endIndex - range!.startIndex) == length else {
            continue
        }

        product = max(product, digits[range!].reduce(1) { $0 * $1 })

        range!.startIndex += 1 // Shift lower bound.
    }
    return product
}

let digits = [7,3,1,6,7,1,7,6,5,3,1,3,3,0,6,2,4,9,1,9,2,2,5,1,1,9,6,7,4,4,2,6,5,7,4,7,4,2,3,5,5,3,4,9,1,9,4,9,3,4,9,6,9,8,3,5,2,0,3,1,2,7,7,4,5,0,6,3,2,6,2,3,9,5,7,8,3,1,8,0,1,6,9,8,4,8,0,1,8,6,9,4,7,8,8,5,1,8,4,3,8,5,8,6,1,5,6,0,7,8,9,1,1,2,9,4,9,4,9,5,4,5,9,5,0,1,7,3,7,9,5,8,3,3,1,9,5,2,8,5,3,2,0,8,8,0,5,5,1,1,1,2,5,4,0,6,9,8,7,4,7,1,5,8,5,2,3,8,6,3,0,5,0,7,1,5,6,9,3,2,9,0,9,6,3,2,9,5,2,2,7,4,4,3,0,4,3,5,5,7,6,6,8,9,6,6,4,8,9,5,0,4,4,5,2,4,4,5,2,3,1,6,1,7,3,1,8,5,6,4,0,3,0,9,8,7,1,1,1,2,1,7,2,2,3,8,3,1,1,3,6,2,2,2,9,8,9,3,4,2,3,3,8,0,3,0,8,1,3,5,3,3,6,2,7,6,6,1,4,2,8,2,8,0,6,4,4,4,4,8,6,6,4,5,2,3,8,7,4,9,3,0,3,5,8,9,0,7,2,9,6,2,9,0,4,9,1,5,6,0,4,4,0,7,7,2,3,9,0,7,1,3,8,1,0,5,1,5,8,5,9,3,0,7,9,6,0,8,6,6,7,0,1,7,2,4,2,7,1,2,1,8,8,3,9,9,8,7,9,7,9,0,8,7,9,2,2,7,4,9,2,1,9,0,1,6,9,9,7,2,0,8,8,8,0,9,3,7,7,6,6,5,7,2,7,3,3,3,0,0,1,0,5,3,3,6,7,8,8,1,2,2,0,2,3,5,4,2,1,8,0,9,7,5,1,2,5,4,5,4,0,5,9,4,7,5,2,2,4,3,5,2,5,8,4,9,0,7,7,1,1,6,7,0,5,5,6,0,1,3,6,0,4,8,3,9,5,8,6,4,4,6,7,0,6,3,2,4,4,1,5,7,2,2,1,5,5,3,9,7,5,3,6,9,7,8,1,7,9,7,7,8,4,6,1,7,4,0,6,4,9,5,5,1,4,9,2,9,0,8,6,2,5,6,9,3,2,1,9,7,8,4,6,8,6,2,2,4,8,2,8,3,9,7,2,2,4,1,3,7,5,6,5,7,0,5,6,0,5,7,4,9,0,2,6,1,4,0,7,9,7,2,9,6,8,6,5,2,4,1,4,5,3,5,1,0,0,4,7,4,8,2,1,6,6,3,7,0,4,8,4,4,0,3,1,9,9,8,9,0,0,0,8,8,9,5,2,4,3,4,5,0,6,5,8,5,4,1,2,2,7,5,8,8,6,6,6,8,8,1,1,6,4,2,7,1,7,1,4,7,9,9,2,4,4,4,2,9,2,8,2,3,0,8,6,3,4,6,5,6,7,4,8,1,3,9,1,9,1,2,3,1,6,2,8,2,4,5,8,6,1,7,8,6,6,4,5,8,3,5,9,1,2,4,5,6,6,5,2,9,4,7,6,5,4,5,6,8,2,8,4,8,9,1,2,8,8,3,1,4,2,6,0,7,6,9,0,0,4,2,2,4,2,1,9,0,2,2,6,7,1,0,5,5,6,2,6,3,2,1,1,1,1,1,0,9,3,7,0,5,4,4,2,1,7,5,0,6,9,4,1,6,5,8,9,6,0,4,0,8,0,7,1,9,8,4,0,3,8,5,0,9,6,2,4,5,5,4,4,4,3,6,2,9,8,1,2,3,0,9,8,7,8,7,9,9,2,7,2,4,4,2,8,4,9,0,9,1,8,8,8,4,5,8,0,1,5,6,1,6,6,0,9,7,9,1,9,1,3,3,8,7,5,4,9,9,2,0,0,5,2,4,0,6,3,6,8,9,9,1,2,5,6,0,7,1,7,6,0,6,0,5,8,8,6,1,1,6,4,6,7,1,0,9,4,0,5,0,7,7,5,4,1,0,0,2,2,5,6,9,8,3,1,5,5,2,0,0,0,5,5,9,3,5,7,2,9,7,2,5,7,1,6,3,6,2,6,9,5,6,1,8,8,2,6,7,0,4,2,8,2,5,2,4,8,3,6,0,0,8,2,3,2,5,7,5,3,0,4,2,0,7,5,2,9,6,3,4,5,0]

//assert(maxAdjacentDigitsProductOfLength(4, digits: digits) == 5832)
//maxAdjacentDigitsProductOfLength(13, digits: digits)
//:
//: ## 9. Special Pythagorean triplet
//:
//: A Pythagorean triplet is a set of three natural numbers, a < b < c, for which, a^2 + b^2 = c^2. For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.
//:
//: There exists exactly one Pythagorean triplet for which a + b + c = 1000. Find the product a * b * c.
//: 
//: ---
//:
//: The solution basically brute-forces checking possible leg values by checking all other criteria. The one criteria not mentioned but inferrable is (right) triangles have additional characteristics.
//:
func pythagoreanTripletForSum(sum: Int) -> [Int]? {
    var triplet: [Int]?
    // Neither can be longer than the hypotenuse, and latter needs to be
    // at least half to be longest side.
    let legMax = sum / 2 - 1
    // Go through candidates (in order) for a, b, c.
    outer: for a in 1...legMax { // Natural numbers start from 1.
        for b in (a + 1)...legMax // a < b
            // Sum of legs must be greater than hypotenuse to be a triangle.
            where a + b > sum / 2
        {
	        // Right triangles are such that 'leg' angles have tangent
            // relations with the legs.
            guard atan(Double(a)/Double(b)) + atan(Double(b)/Double(a)) == M_PI_2 else { continue }
            // Needs to be a right triangle's hypotenuse.
            let c = sqrt(Double(pow(a, 2) + pow(b, 2)))
            guard c % 1.0 == 0 else { continue }
            // Needs to fit sum.
            guard a + b + Int(c) == sum else { continue }
            // Commit.
            triplet = [a, b, Int(c)]
            break outer
        }
    }
    return triplet
}

assert(pythagoreanTripletForSum(12)! == [3, 4, 5])
//print(pythagoreanTripletForSum(1000)!.reduce(1) { $0 * $1 })
//:
//: ## 10. Summation of Primes
//:
//: The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17. Find the sum of all the primes below two million.
//:
//: ---
//:
extension Int {
    func sumOfPrimesBelow() -> Int {
        let s = SieveOfEratosthenes()
        var sum = 2
        while s.lastPrime < self {
            sum += s.lastPrime
            s.purgeNextMultiples()
            s.updateCursorIndex()
        }
        return sum
    }
}
//assert(10.sumOfPrimesBelow() == 17)
//assert(100.sumOfPrimesBelow() == 1060)
//print(2000000.sumOfPrimesBelow())
