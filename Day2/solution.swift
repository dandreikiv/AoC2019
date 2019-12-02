import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var a = string.split(separator: ",").compactMap{Int($0)}

func computeProgram(_ a: [Int], noun: Int, verb: Int) -> Int {
    var a = a

    a[1] = noun
    a[2] = verb

    var pointer = 0

    while pointer < a.count - 4{
        let op = a[pointer]
        let pi1 = a[pointer + 1]
        let pi2 = a[pointer + 2]
        let di = a[pointer + 3]

        if op == 1 {
            a[di] = a[pi1] + a[pi2]
        } else if op == 2 {
            a[di] = a[pi1] * a[pi2]
        } else if op == 99 {
            break
        }

        pointer += 4
    }
    
    return a[0]
}

for noun in 0...99 {
    for verb in 0...99 {
        let result =  computeProgram(a, noun: noun, verb: verb)
        if result == 19690720 {
            print("result: \(noun * 100 + verb)")
            break
        }
    }
}