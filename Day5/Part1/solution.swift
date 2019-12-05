import Foundation

let url = URL(fileURLWithPath: "input.txt")
let string = try String(contentsOf: url)
var a = string.split(separator: ",").compactMap{Int($0)}

let input = 1

var p = 0

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
        a[i] = input
        p += 2
    }
    else if opc == 4 {
        let i = (p1Mode == 0) ? a[p + 1] : p + 1
        print(a[i])
        p += 2
    }
}