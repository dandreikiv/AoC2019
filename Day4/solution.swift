import Foundation

/**
An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.

Given this additional criterion, but still ignoring the range rule, the following are now true:

112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).

Your puzzle input is 168630-718098.
*/
var count = 0
for i in 168630...718098 {
    let digits = i.description.compactMap { Int(String($0)) }
    let adjacentGroup = NSCountedSet(array: digits)

    var increasing = true
    for idx in 0..<digits.count - 1 {
        if digits[idx] > digits[idx + 1] {
            increasing = false
            break
        }
    }

    var hasGroupOfTwo = false
    for digit in adjacentGroup {
        if adjacentGroup.count(for: digit) == 2 {
            hasGroupOfTwo = true
            break
        } 
    }
    if increasing && hasGroupOfTwo {
        count+=1
    }
}

print(count)