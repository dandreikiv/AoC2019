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

struct Point: Hashable, Equatable {
    var x, y: Int
}

var robot: Point = .init(x: 0, y: 0)
var s = Set<Point>()
var color: [Point: Int] = [.init(x: 0, y: 0): 1]

func getColor(at point: Point) -> Int {
    return color[point] ?? 0
}

func setColor(_ c: Int, at point: Point) {
    color[point] = c
}

func getInput() -> Int {
    let c = getColor(at: .init(x: robot.x, y: robot.y))
    return c
}

enum Direction {
    case up, down, left, right
}

var outputCount: Int = 0
var direction: Direction = .up

func processOutput(_ output: Int) -> Void {
    if (outputCount % 2) == 0 {
         // set color
        setColor(output, at: robot)
    }
    else if (outputCount % 2) == 1 { 
        // turn left or right
        switch direction {
            case .up: 
                // turn left 
                if output == 0 { 
                    direction = .left 
                    robot.x -=  1
                }
                // turn right
                if output == 1 { 
                    direction = .right
                    robot.x +=  1
                 }
            case .left: 
                // turn left 
                if output == 0 { 
                    direction = .down 
                    robot.y += 1
                }
                // turn right
                if output == 1 { 
                    direction = .up
                    robot.y -= 1
                 }
            case .down: 
                // turn left 
                if output == 0 { 
                    direction = .right 
                    robot.x += 1
                }
                // turn right
                if output == 1 { 
                    direction = .left
                    robot.x -= 1
                 }
            case .right: 
                // turn left 
                if output == 0 { 
                    direction = .up 
                    robot.y -= 1
                }
                // turn right
                if output == 1 { 
                    direction = .down
                    robot.y += 1
                 }
        } 
    }
    outputCount += 1
}

compute(code: code, input: getInput, output: processOutput)
var maxX = Int.min
var maxY = Int.min
for col in color {
    if col.key.x > maxX {  maxX = col.key.x  }
    if col.key.y > maxY {  maxY = col.key.y  }
}

print(maxX, maxY)
var array = Array(repeating: 0, count: (maxX + 1) * (maxY + 1))

for col in color {
    let key = col.key
    let idx = key.x + key.y * maxX
    array[idx] = col.value
}

var prt = ""
for a in array {
    prt += (a == 0) ? " " : "x"
    if prt.count == maxX {
        print(prt)
        prt = ""
    }
}

