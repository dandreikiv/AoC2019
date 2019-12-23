import Foundation

let url = URL(fileURLWithPath: "input.txt")
let input = try String(contentsOf: url)
var lines = input.split(separator: "\n")

struct Element: Equatable, CustomDebugStringConvertible {
    let name: String
    let quantity: Int

    var debugDescription: String {
        return "\(quantity) \(name)"
    }
}

struct Chain: CustomDebugStringConvertible {
    let multiplier: Int
    let elements: [Element]

    var debugDescription: String {
        return "\(multiplier) x \(elements)"
    }
}

class ChemicalReaction {
    let lines: [String] 
    var data: [String: Chain] = [:]

    init(input: String) {
        self.lines = input.split(separator: "\n").map(String.init)

        for l in lines {
            let parts = l.components(separatedBy: "=>")
            let element = parseElement(parts[1])
            let chain = parseChain(parts[0])

            data[element.name] = .init(multiplier: element.quantity, elements: chain)            
        }
    }

    func parseElement(_ string: String) -> Element {
        let parts = string.split(separator: " ").map(String.init)
        let q = Int(parts[0]) ?? 0
        let n = parts[1]

        return .init(name: n, quantity: q)
    }

    func parseChain(_ string: String) -> [Element] {
        return string.split(separator: ",").map{parseElement(String($0))}
    }

    func isBasicElement(_ el: Element) -> Bool {
        guard let chain = data[el.name] else { return false }
        guard chain.elements.count == 1 else { return false }

        return chain.elements[0].name == "ORE"
    }

    func multiplyElements(_ elements: [Element], by multiplier: Int) -> [Element] {
        return elements.map { return Element(name: $0.name, quantity: $0.quantity * multiplier) }
    }

    func solve() {
        var finished = false

        while !finished {

            guard let chain = data["FUEL"] else { return }
        
            var elements = chain.elements
            var replaced = false
            for el in chain.elements {
                if isBasicElement(el) { continue }

                // check if this element is not in other element chains
                var allowReplace = true

                for d in data {
                    if d.key == "FUEL" { continue }

                    for inel in d.value.elements { 
                        if inel.name == el.name { 
                            allowReplace = false; break 
                        }
                    }  
                } 

                if allowReplace == false { continue }
                
                // Chain to replece element
                if let ch = data[el.name] {
                    replaced = true
                    elements.removeAll { $0 == el  }
                    data.removeValue(forKey: el.name )
                    let multiplier = el.quantity <= ch.multiplier ? 1 : Int(ceil( Float(el.quantity) / Float(ch.multiplier) ))
                    elements += multiplyElements(ch.elements, by: multiplier) 
                }

                if replaced {
                    let newChain = Chain(multiplier: chain.multiplier, elements: mergeElements(elements))
                    data["FUEL"] = newChain
                    break
                }
            }

            finished = (replaced == false)
        }

        guard let chain = data["FUEL"] else { return }
        var total = 0
        for el in chain.elements {
            guard let oreChain = data[el.name] else { continue }
            guard let ore = oreChain.elements.first else { continue }
            
            total += Int(ceil(Float(el.quantity) / Float(oreChain.multiplier)) * Float(ore.quantity))
        }
        print(total)
    }

    func mergeElements(_ elements: [Element]) -> [Element] {
        var d: [String: Int] = [:]
        for el in elements {
            d[el.name] = (d[el.name] ?? 0) + el.quantity
        }
        return d.map { return Element(name: $0.key, quantity: $0.value)} 
    }

    func printData() {
        for d in data {
            print(d.key, d.value)
        }
    }
}

let chr = ChemicalReaction(input: input)
chr.solve()