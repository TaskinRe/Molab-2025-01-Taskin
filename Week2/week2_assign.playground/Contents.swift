import UIKit
import PlaygroundSupport

// Function to load ASCII text from the resource folder
func loadASCIIArt(filename: String) -> String? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else {
        print("Failed to locate \(filename).txt in resources.")
        return nil
    }
    
    // Updated to use init(contentsOf:encoding:) instead of deprecated init(contentsOf:)
    do {
        let text = try String(contentsOf: fileURL, encoding: .utf8)
        return text
    } catch {
        print("Error loading the file: \(error)")
        return nil
    }
}

// Function to create an image from ASCII art
func createASCIIImage(from text: String, font: UIFont = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)) -> UIImage {
    let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.black]
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    // Calculate size required for the text
    let textSize = attributedString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                 context: nil).size
    
    // Create the image context
    let renderer = UIGraphicsImageRenderer(size: textSize)
    let image = renderer.image { context in
        UIColor.white.setFill() // Background color
        context.fill(CGRect(origin: .zero, size: textSize))
        
        attributedString.draw(at: CGPoint(x: 0, y: 0))
    }
    
    return image
}

// Load ASCII art from cat.txt
if let asciiArt = loadASCIIArt(filename: "cat") {
    let asciiImage = createASCIIImage(from: asciiArt)
    
    // Display the image in the Playground live view
    let imageView = UIImageView(image: asciiImage)
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .white
    imageView.frame = CGRect(x: 0, y: 0, width: asciiImage.size.width, height: asciiImage.size.height)
    
    PlaygroundPage.current.liveView = imageView
} else {
    print("Could not load ASCII art.")
}
