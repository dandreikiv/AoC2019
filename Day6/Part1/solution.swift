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

print(obj)
print(orbit)

func traverse(key: String, path: Set<String>) {
    if let next = orbit[key] {
        var path = path
        path.insert("\(key)->\(next)")
        traverse(key: next, path: path)
    }
}

var count = 0

for o in obj {    
    var s = Set<String>()
    var key = o
    while true {
        if let next = orbit[key] {
            s.insert("\(key)->\(next)")
            key = next
        } else {
            break
        }
    }
    count += s.count
}

print(count)

