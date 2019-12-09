import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var digits: [Int] = []

for (_, ch) in string.enumerated() {
    guard let digit = Int("\(ch)") else { continue }
    digits.append(digit)
}
print(digits.count)


var layer: [[Int]] = []

var i = 0
var di = 0

var count0 = 0
var count1 = 0
var count2 = 0

for d in digits {
    if d == 0 {
        count0 += 1
    }
    else if d == 1 {
        count1 += 1
    }
    else if d == 2 {
        count2 += 1
    }

    di += 1
    if di % 150 == 0 {
        layer.append([count0, count1, count2])
        count0 = 0
        count1 = 0
        count2 = 0
    }
}

var min0 = Int.max
var min0Index = 0 

for i in 0..<layer.count {
    let l = layer[i] 
    print(layer[i], l[0] + l[1] + l[2])
    let zeros = layer[i][0]
    if min0 > zeros {
        min0 = zeros
        min0Index = i
    }
}

print(layer[min0Index])
