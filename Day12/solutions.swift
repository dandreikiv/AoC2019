import Foundation

let x0 = [-3, 10, -3, 8]
let y0 = [-6, 7, -7, 0]
let z0 = [ 6, -9,  9, -4]

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
    for i in 0...x.count - 2 {
        for j in (i+1)...x.count - 1 {
            if i == j { continue }
            if x[i] < x[j] { 
                vx[i] += 1 
                vx[j] -= 1
            }

            if x[i] > x[j] { 
                vx[i] -= 1 
                vx[j] += 1 
            }
            
            // if y[i] < y[j] { 
            //     vy[i] += 1 
            //     vy[j] -= 1 
            // }

            // if y[i] > y[j] { 
            //     vy[i] -= 1 
            //     vy[j] += 1 
            // }
            
            // if z[i] < z[j] { 
            //     vz[i] += 1 
            //     vz[j] -= 1 
            // }

            // if z[i] > z[j] { 
            //     vz[i] -= 1 
            //     vz[j] += 1 
            // }
        }
    }
    
    for i in 0...x.count - 1 {
        x[i] += vx[i]
        // y[i] += vy[i]
        // z[i] += vz[i]
    }
    
    // if (x0 == x && y0 == y && z0 == z) && (vx0 == vx && vy0 == vy && vz0 == vz) {
    if (x0 == x) && (vx0 == vx) {
        break
    }
    
    step += 1

    // for i in 0...x.count - 1 {
    //     print(x[i], y[i], z[i], "|", vx[i], vy[i], vz[i])
    // }
    // print("============\(step)===============")
}

// var result = 0
// for i in 0...x.count - 1 {
//     result += (abs(x[i]) + abs(y[i]) + abs(z[i])) * (abs(vx[i]) + abs(vy[i]) + abs(vz[i]))
// }

print(step + 1)
