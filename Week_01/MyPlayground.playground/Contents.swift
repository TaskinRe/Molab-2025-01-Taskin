import UIKit
import PlaygroundSupport

// Function to create a flower shape using emojis and text art
func createFlowerArt(petalSize: Int) -> String {
    var flowerArt = ""
    
    // The petals using emoji 🌸
    let petal = "🌸"
    
    // Create the top petals
    for i in 0..<petalSize {
        flowerArt += String(repeating: " ", count: petalSize - i - 1) // Left padding
        flowerArt += String(repeating: petal, count: i + 1) // Top petals
        flowerArt += "\n"
    }
    
    // Create the center stem of the flower
    let stem = "🌿"
    flowerArt += String(repeating: " ", count: petalSize - 1) // Left padding for the stem
    flowerArt += stem + "\n"
    
    // Create the bottom petals
    for i in 0..<petalSize {
        flowerArt += String(repeating: " ", count: i + 1) // Left padding
        flowerArt += String(repeating: petal, count: petalSize - i) // Bottom petals
        flowerArt += "\n"
    }

    return flowerArt
}

// Set the size of the flower petals
let petalSize = 5

// Create the flower art and print it
let flowerTextArt = createFlowerArt(petalSize: petalSize)
print(flowerTextArt)

// Display the flower in Playground live view
let label = UILabel()
label.numberOfLines = 0
label.text = flowerTextArt
label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
label.frame = CGRect(x: 0, y: 0, width: 300, height: 300)

PlaygroundPage.current.liveView = label
