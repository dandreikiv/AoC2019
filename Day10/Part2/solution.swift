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

func distanceFrom(_ center: Point, to point: Point) -> Float {
    let xdiff = Float(center.x - point.x)
    let ydiff = Float(center.y - point.y)
    return sqrt(xdiff * xdiff + ydiff * ydiff)
}

func angle(center: Point, asteroid: Point) -> Float {
    let x = Float(asteroid.x - center.x)
    let y = Float(center.y - asteroid.y)

    var a = atan2(y, x) * 180 / .pi
    
    a = (a >= 0) ? a : a + 360
    a = (360 - a + 90)
    a = (a >= 360) ? a - 360 : a
    
    return a
}

func dectedAsteroids(_ center: Point) -> [Point] {
    var asteroids: [Float: Point] = [:]

    for p in points {
        if center == p { continue }

        let ang = angle(center: center, asteroid: p)

        if let asteroid = asteroids[ang] {
            let asteroidDistance = distanceFrom(center, to: asteroid)
            let pointDistance = distanceFrom(center, to: p)

            if pointDistance < asteroidDistance {
                 asteroids[ang] = p
            }
        }
        else {
            asteroids[ang] = p
        }   
    }
    return Array(asteroids.values)
}

var maxCount = 0
var maxPoint: Point = .init(x: 0, y: 0)
for point in points {
    let c = dectedAsteroids(point).count
    if c > maxCount {
        maxCount = c
        maxPoint = point
    }
}

let center = maxPoint
print(maxPoint, maxCount)
var count = 1

while true {
    let asteroids = dectedAsteroids(maxPoint).sorted { p1, p2 in 
        let d1 = angle(center: center, asteroid: p1)
        let d2 = angle(center: center, asteroid: p2)
        return d1 < d2
    }

    if asteroids.isEmpty { break }

    for asteroid in asteroids {
        print(asteroid, "angle: \(angle(center: center, asteroid: asteroid))", "number: \(count)")
        if let index = points.firstIndex(of: asteroid) {
            points.remove(at: index)
        }
        count += 1
    }
    print("Next round")
}



