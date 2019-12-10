import Foundation

struct Point: Equatable {
    let x, y: Int
}

struct MD: Hashable {
    let xsign, ysign: Int
    let ration: Float
}

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var lines = string.split(separator: "\n")
var rowsCount = lines.count
var collCount = lines[0].count

var points: [Point] = []

var y = 0
for line in lines {
    var x = 0
    for ch in line {
        if ch == "#" {
            points.append(.init(x: x, y: y))
        }
        x += 1
    }
    y += 1
}

func countForPoint(_ center: Point) -> Int {
    var set1 = Set<MD>()

    for p in points {
        if center == p { continue }

        let xdiff = p.x - center.x
        let ydiff = p.y - center.y
    
        let ratio = Float(xdiff) / Float(ydiff)
        let m: MD = .init(xsign: xdiff >= 0 ? 1 : 0 , ysign: ydiff >= 0 ? 1 : 0, ration: ratio) 
        set1.insert(m)
    }
    return set1.count 
}

var maxCount = 0
var maxPoint: Point = .init(x: 0, y: 0)
for point in points {
    let c = countForPoint(point)
    if c > maxCount {
        maxCount = c
        maxPoint = point
    }
}

print(maxPoint, maxCount)



