import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var a = string.split(separator: ",").compactMap{Int($0)}

a[1] = 12
a[2] = 2

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

print(a[0])