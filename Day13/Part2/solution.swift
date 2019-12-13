import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var code = string.split(separator: ",").compactMap{Int($0)} 
 
 func compute(code a: [Int], input: () -> Int, output: (Int) -> Void) {
    var a = a
    var p = 0
    
    var base = 0
    
    func pindex(mode: Int, offset: Int) -> Int {
        let idx: Int
        
        if mode == 0 { idx = a[p + offset] }
        else if mode == 1 { idx = p + offset }
        else if mode == 2 { idx = base + a[p + offset] }
        else { idx = -1 }
        
        if idx > a.count - 1 {
            let diff = idx - a.count + 1
            let zeros: [Int] = Array(repeating: 0, count: diff)
            a += zeros
        }
        
        return idx
    }

    while true {
        let op = a[p]

        let opc = op % 100
        
        if opc == 99 {
            print("program is finished")
            break
        }
        
        let p1Mode = (op / 100) % 10
        let p2Mode = (op / 100) / 10 % 10
        let p3Mode = (op / 100) / 100 % 10
        
        if opc == 1 {
            let p1i = pindex(mode: p1Mode, offset: 1)
            let p2i = pindex(mode: p2Mode, offset: 2)
            let di  = pindex(mode: p3Mode, offset: 3)
            
            a[di] = a[p1i] + a[p2i]
            p += 4
        }
        else if opc == 2 {
            let p1i = pindex(mode: p1Mode, offset: 1)
            let p2i = pindex(mode: p2Mode, offset: 2)
            let di  = pindex(mode: p3Mode, offset: 3)
            
            a[di] = a[p1i] * a[p2i]
            p += 4
        }
        else if opc == 3 {
            let i = pindex(mode: p1Mode, offset: 1)
            a[i] = input()
            p += 2
        }
        else if opc == 4 {
            let i = pindex(mode: p1Mode, offset: 1)
            output(a[i])
            p += 2
        }
        else if opc == 5 {
            // Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter.
            // Otherwise, it does nothing.
            let p1i = pindex(mode: p1Mode, offset: 1)
            let p2i = pindex(mode: p2Mode, offset: 2)
            
            p = (a[p1i] > 0) ? a[p2i] : p + 3
        }
        else if opc == 6 {
            // Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter.
            // Otherwise, it does nothing.
            let p1i = pindex(mode: p1Mode, offset: 1)
            let p2i = pindex(mode: p2Mode, offset: 2)
            
            p = (a[p1i] == 0) ? a[p2i] : p + 3
        }
        else if opc == 7 {
            // Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter.
            // Otherwise, it stores 0.
            let p1i = pindex(mode: p1Mode, offset: 1)
            let p2i = pindex(mode: p2Mode, offset: 2)
            let di  = pindex(mode: p3Mode, offset: 3)
            
            a[di] = (a[p1i] < a[p2i]) ? 1 : 0
            p += 4
        }
        else if opc == 8 {
            // Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter.
            // Otherwise, it stores 0.
            let p1i = pindex(mode: p1Mode, offset: 1)
            let p2i = pindex(mode: p2Mode, offset: 2)
            let di  = pindex(mode: p3Mode, offset: 3)
            
            a[di] = (a[p1i] == a[p2i]) ? 1 : 0
            p += 4
        }
        else if opc == 9 {
            let p1i = pindex(mode: p1Mode, offset: 1)
            base += a[p1i]
            p += 2
        }
    }
}

struct Pos: Hashable, Equatable {
    let x, y: Int
}

var game: [Pos: Int] = [:]
var paddle = Pos(x: 0, y: 0)
var ball = Pos(x: 0, y: 0) 
var jp = 0 // {0, 1, -1}

var outputCount = 0
var x: Int = -1
var y: Int = -1

func getInput() -> Int { 
    var input = 0 
    if ball.x != paddle.x {
        input = (ball.x > paddle.x) ? 1 : -1
    }
    return input    
} 

func precessOutput(_ output: Int) {
    if outputCount == 0 {
        x = output
    }
    else if outputCount == 1 {
        y = output
    }
    else if outputCount == 2 {
        game[.init(x: x, y: y)] = output
        if output == 4 {
            ball = .init(x: x, y: y)
        }
        if output == 3 {
            paddle = .init(x: x, y: y)
        }
    }

    outputCount += 1
    if outputCount > 2 {
        outputCount = 0
    }
}

compute(code: code, input: getInput, output: precessOutput)

print(game[.init(x: -1, y: 0)] ?? 0)


