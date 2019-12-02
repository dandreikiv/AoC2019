import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
let input = string.split(separator: "\n").compactMap(Float.init)

// Part 1
let fuel = input.map { n in floorf(n / 3) - 2 }.reduce(0, +)
print(fuel)

// Part 2
func requiredFuel(for moduleMass: Float) -> Float {
    return floorf(moduleMass / 3) - 2
}

var total: Float = 0
for n in input {
    var mas = requiredFuel(for: n)
    while mas > 0 {
        total += mas
        mas = requiredFuel(for: mas)
    }
}

RunLoop.main.run()