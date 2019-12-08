import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var a = string.split(separator: "\n")

var orbit: [String: String] = [:]
var obj = Set<String>()
for p in a {
    let parts = p.split(separator: ")")
    let l = String(parts[0])
    let r = String(parts[1])
    orbit[r] = l
    obj.insert(r)
    obj.insert(l)
}

func path(from point: String) -> [String] {
    var s: [String] = []
    var key = point
    while true {
        if let next = orbit[key] {
            s.append(next)
            key = next
        } else {
            break
        }
    }
    return s
}

let youPath = path(from: "YOU")
let sanPath = path(from: "SAN")

print(youPath)
print(sanPath)

var stop = false
for i in 0..<youPath.count {
    for j in 0..<sanPath.count {
        if youPath[i] == sanPath[j] {
            print(i, j)
            print(i + j)
            stop = true
            break
        }
    }
    if stop {
        break
    }
}


// print(count)

