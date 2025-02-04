import PlaygroundSupport
import UIKit

let rows = 40
let columns = 80
let symbols: [String] = ["!", "@", "#", "$", "%"]
var grid = [[String]](repeating: [String](repeating: " ", count: columns), count: rows)

// Generate multiple concentric circles with variations
for layer in 0..<5 {
    let layerRadius = Double(15 - layer * 2)
    let centerX = Double(columns/2) + Double(layer * 2)
    let centerY = Double(rows/2) + Double(layer * 3)
    
    for angle in stride(from: 0.0, to: Double.pi * 2, by: 0.02) {
        let variance = Double.random(in: -1.5...1.5)
        let x = centerX + (layerRadius + variance) * cos(angle) * 2 // Horizontal stretch
        let y = centerY + (layerRadius + variance) * sin(angle)
        
        let char = symbols.randomElement()!
        
        if Int(y) >= 0 && Int(y) < rows && Int(x) >= 0 && Int(x) < columns {
            grid[Int(y)][Int(x)] = char
        }
    }
}

// Create ASCII art string
let output = grid.map { $0.joined() }.joined(separator: "\n")

// Configure display view
let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
textView.font = UIFont.monospacedSystemFont(ofSize: 8, weight: .regular)
textView.text = output
textView.backgroundColor = .black
textView.textColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)

PlaygroundPage.current.liveView = textView
