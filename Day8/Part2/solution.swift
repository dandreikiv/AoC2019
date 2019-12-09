import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var digits: [Int] = []

for (_, ch) in string.enumerated() {
    guard let digit = Int("\(ch)") else { continue }
    digits.append(digit)
}

var layer: [Int] = Array(repeating: 2, count: 150)

// 0 is black, 1 is white, and 2 is transparent

var i = 0
for d in digits {
    if layer[i] == 2 {
        layer[i] = d
    }
    
    i += 1

    if i % 150 == 0 {
        i = 0
    }
}

for i in 0...5 {
    let index = i*25
    let length = 24
    print(layer[index...index+length].map({ 
        if $0 == 0 { 
            return " " 
        } 
        return "+" 
    }).joined())
}

