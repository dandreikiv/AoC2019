import Foundation

let x0 = [-8, 5, 2, 9]
let y0 = [-10, 5, -7, -8]
let z0 = [ 0, 10,  3, -3]

var x = x0
var y = y0
var z = z0

let vx0 = [0, 0, 0, 0]
let vy0 = [0, 0, 0, 0]
let vz0 = [0, 0, 0, 0]

var vx = vx0
var vy = vy0
var vz = vz0

var step = 0
while step < 100 {
    for i in 0...x.count - 1 {
        for j in 0...x.count - 1 {
            if i == j { continue }
            if x[i] < x[j] { vx[i] += 1 }
            if x[i] > x[j] { vx[i] -= 1 }
            
            if y[i] < y[j] { vy[i] += 1 }
            if y[i] > y[j] { vy[i] -= 1 }
            
            if z[i] < z[j] { vz[i] += 1 }
            if z[i] > z[j] { vz[i] -= 1 }
        }
    }
    
    for i in 0...x.count - 1 {
        x[i] += vx[i]
        y[i] += vy[i]
        z[i] += vz[i]
    }
    
    // if (x0 == x && y0 == y && z0 == z) && (vx0 == vx && vy0 == vy && vz0 == vz) {
    //     break
    // }
    
    step += 1

    if step % 1 == 0 {
        for i in 0...x.count - 1 {
            print(x[i], y[i], z[i], "|", vx[i], vy[i], vz[i])
        }
        print("============\(step)===============")
    }
}


var result = 0
for i in 0...x.count - 1 {
    result += (abs(x[i]) + abs(y[i]) + abs(z[i])) * (abs(vx[i]) + abs(vy[i]) + abs(vz[i]))
}

print(result)
