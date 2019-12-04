import Foundation

/**
It is a six-digit number.
The value is within the range given in your puzzle input.
Two adjacent digits are the same (like 22 in 122345).
Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
Other than the range rule, the following are true:

111111 meets these criteria (double 11, never decreases).
223450 does not meet these criteria (decreasing pair of digits 50).
123789 does not meet these criteria (no double).
How many different passwords within the range given in your puzzle input meet these criteria?

Your puzzle input is 168630-718098.
*/
var count = 0
for i in 168630...718098 {
    let s = i.description
    let digits = s.compactMap { Int(String($0)) }

    var hasAdjacent = false
    var increasing = true
    var prevDigit = digits[0]

    for d in digits[1...] {
        if d < prevDigit {
            increasing = false
            break
        }

        if d == prevDigit {
            hasAdjacent = true
        }

        prevDigit = d
    }

    if hasAdjacent && increasing {
        count+=1
    }
}

print(count)