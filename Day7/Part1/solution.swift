import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var code = string.split(separator: ",").compactMap{Int($0)}

func compute(code a: [Int], input: [Int]) -> Int {
    var a = a
    var p = 0

    var input = input
    var output = 0

    while true {
        let op = a[p]
        let opc = op % 100
        
        if opc == 99 { break }
        
        let p1Mode = (op / 100) % 10
        let p2Mode = (op / 100) / 10
        let p3Mode = (op / 100) / 100
        
        if opc == 1 {
            let p1i = (p1Mode == 0) ? a[p + 1] : p + 1
            let p2i = (p2Mode == 0) ? a[p + 2] : p + 2
            let di  = (p3Mode == 0) ? a[p + 3] : p + 3
            
            a[di] =  a[p1i] + a[p2i]
            p += 4
        }
        else if opc == 2 {
            let p1i = (p1Mode == 0) ? a[p + 1] : p + 1
            let p2i = (p2Mode == 0) ? a[p + 2] : p + 2
            let di  = (p3Mode == 0) ? a[p + 3] : p + 3
            
            a[di] =  a[p1i] * a[p2i]
            p += 4
        }
        else if opc == 3 {
            let i = (p1Mode == 0) ? a[p + 1] : p + 1
            a[i] = input[0]
            input.remove(at: 0)
            p += 2
        }
        else if opc == 4 {
            let i = (p1Mode == 0) ? a[p + 1] : p + 1
            output = a[i]
            return output
            p += 2
        }
        else if opc == 5 {
            // Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter.
            // Otherwise, it does nothing.
            let p1i = (p1Mode == 0) ? a[p + 1] : p + 1
            let p2i = (p2Mode == 0) ? a[p + 2] : p + 2
            
            p = (a[p1i] > 0) ? a[p2i] : p + 3
        }
        else if opc == 6 {
            // Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter.
            // Otherwise, it does nothing.
            let p1i = (p1Mode == 0) ? a[p + 1] : p + 1
            let p2i = (p2Mode == 0) ? a[p + 2] : p + 2
            
            p = (a[p1i] == 0) ? a[p2i] : p + 3
        }
        else if opc == 7 {
            // Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter.
            // Otherwise, it stores 0.
            let p1i = (p1Mode == 0) ? a[p + 1] : p + 1
            let p2i = (p2Mode == 0) ? a[p + 2] : p + 2
            let p3i = (p3Mode == 0) ? a[p + 3] : p + 3
            
            a[p3i] = (a[p1i] < a[p2i]) ? 1 : 0
            p += 4
        }
        else if opc == 8 {
            // Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter.
            // Otherwise, it stores 0.
            let p1i = (p1Mode == 0) ? a[p + 1] : p + 1
            let p2i = (p2Mode == 0) ? a[p + 2] : p + 2
            let p3i = (p3Mode == 0) ? a[p + 3] : p + 3
            
            a[p3i] = (a[p1i] == a[p2i]) ? 1 : 0
            p += 4
        }
    }

    return output
}

extension Array {
    func decompose() -> (Element, [Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

func between<T>(_ x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x, tail).map { [head] + $0 }
}

func permutations<T>(_ xs: [T]) -> [[T]] {
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(tail).flatMap { between(head, $0) }
}

let phases = permutations([0, 1, 2, 3, 4])

var max: Int = 0
var maxPhase: [Int]
for phase in phases {
    var input = 0
    for p in phase {
        let output = compute(code: code, input: [p, input])
        input = output
    }
    print(input)
    print(phase, input)
    if input > max { 
        max = input 
    }
}

print(max)

