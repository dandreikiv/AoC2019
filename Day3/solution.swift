import Foundation

typealias Point = (x: Float, y: Float)
typealias Line = (start: Point, end: Point)

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var wires = string.split(separator: "\n")

/**
    How to calculate the point where two lines intersect
    https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-point-where-two-lines-intersect
 */
func linesCross(start1: Point, end1: Point, start2: Point, end2: Point) -> Point? {
    // calculate the differences between the start and end X/Y positions for each of our points
    let delta1x = end1.x - start1.x
    let delta1y = end1.y - start1.y
    let delta2x = end2.x - start2.x
    let delta2y = end2.y - start2.y

    // create a 2D matrix from our vectors and calculate the determinant
    let determinant = delta1x * delta2y - delta2x * delta1y

    if abs(determinant) < 0.0001 {
        // if the determinant is effectively zero then the lines are parallel/colinear
        return nil
    }

    // if the coefficients both lie between 0 and 1 then we have an intersection
    let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

    if ab > 0 && ab < 1 {
        let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

        if cd > 0 && cd < 1 {
            // lines cross – figure out exactly where and return it
            let intersectX = start1.x + ab * delta1x
            let intersectY = start1.y + ab * delta1y
            return (intersectX, intersectY)
        }
    }

    // lines don't cross
    return nil
}

func linesForWire(_ wire: String) -> [Line] {
    var lines: [Line] = []

    var startPoint: Point = (x: 0, y: 0)
    
    for step in wire.split(separator: ",") {
        guard let direction = step.first else { break }

        let startIndex = step.index(step.startIndex, offsetBy: 1)
        guard let distance = Float(String(step[startIndex...])) else { break }
        
        var endPoint = startPoint
        
        switch direction {
            case "R": endPoint.x += distance
            case "L": endPoint.x -= distance
            case "D": endPoint.y -= distance
            case "U": endPoint.y += distance
            default: break
        }
        lines.append(Line(start: startPoint, end: endPoint))
        startPoint = endPoint
    }

    return lines
}

let wire1 = String(wires[0])
let wire2 = String(wires[1])

let lines1 = linesForWire(wire1)
let lines2 = linesForWire(wire2)

var crossPoints: [Point] = []

for l1 in lines1 {
    for l2 in lines2 {
        if let cross = linesCross(start1: l1.start, end1: l1.end, start2: l2.start, end2: l2.end) {
            crossPoints.append(cross)
        }
    }
}

var minDistance: Float = Float(Int.max)

for cross in crossPoints {
    minDistance = min(minDistance, abs(cross.x) + abs(cross.y))
}

print(minDistance)