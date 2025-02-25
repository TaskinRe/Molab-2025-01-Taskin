import SwiftUI
import PlaygroundSupport

struct ArtisticView: View {
    let gridSize = 12
    let colors: [Color] = [
        Color(red: 0.95, green: 0.8, blue: 0.6, opacity: 0.9),  // Peach
        Color(red: 0.7, green: 0.8, blue: 0.9, opacity: 0.8),   // Sky
        Color(red: 0.8, green: 0.9, blue: 0.7, opacity: 0.7),    // Mint
        Color(red: 0.95, green: 0.7, blue: 0.8, opacity: 0.8),   // Pink
        Color(red: 0.8, green: 0.7, blue: 0.95, opacity: 0.7),   // Lavender
        Color.white.opacity(0.8),
        Color(red: 0.9, green: 0.4, blue: 0.4, opacity: 0.6)    // Coral
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background gradient
                RadialGradient(
                    gradient: Gradient(colors: [Color.indigo, Color.black]),
                    center: .center,
                    startRadius: 0,
                    endRadius: max(geo.size.width, geo.size.height) * 0.8
                )
                .blur(radius: 20)
                .overlay(Color.black.opacity(0.4))
                .ignoresSafeArea()
                
                Canvas { context, size in
                    let cellSize = min(size.width, size.height) / CGFloat(gridSize)
                    
                    for row in 0..<gridSize {
                        for col in 0..<gridSize {
                            let baseX = CGFloat(col) * cellSize
                            let baseY = CGFloat(row) * cellSize
                            
                            // Add slight position jitter
                            let x = baseX + CGFloat.random(in: -3...3)
                            let y = baseY + CGFloat.random(in: -3...3)
                            
                            let color = colors.randomElement()!
                            
                            let shapeType = Int.random(in: 0...4)
                            
                            switch shapeType {
                            case 0: // Diagonal line
                                var path = Path()
                                if Bool.random() {
                                    path.move(to: CGPoint(x: x, y: y))
                                    path.addLine(to: CGPoint(x: x + cellSize, y: y + cellSize))
                                } else {
                                    path.move(to: CGPoint(x: x + cellSize, y: y))
                                    path.addLine(to: CGPoint(x: x, y: y + cellSize))
                                }
                                context.stroke(
                                    path,
                                    with: .color(color),
                                    lineWidth: CGFloat.random(in: 1...3)
                                )
                                
                            case 1: // Circle with random size
                                let maxRadius = cellSize * CGFloat.random(in: 0.3...0.7)
                                let rect = CGRect(
                                    x: x + (cellSize - maxRadius)/2,
                                    y: y + (cellSize - maxRadius)/2,
                                    width: maxRadius,
                                    height: maxRadius
                                )
                                context.fill(Path(ellipseIn: rect), with: .color(color))
                                
                            case 2: // Rotated rounded rectangle
                                let inset = cellSize * 0.1
                                var rect = CGRect(x: x + inset, y: y + inset,
                                                width: cellSize - inset*2,
                                                height: cellSize - inset*2)
                                rect = rect.insetBy(dx: CGFloat.random(in: 0...4),
                                        dy: CGFloat.random(in: 0...4))
                                
                                let rotation = Angle.degrees(Double.random(in: 0...360))
                                var path = Path(roundedRect: rect, cornerRadius: 8)
                                
                                let center = CGPoint(x: rect.midX, y: rect.midY)
                                path = path.applying(
                                    CGAffineTransform(translationX: -center.x, y: -center.y)
                                        .rotated(by: rotation.radians)
                                        .translatedBy(x: center.x, y: center.y)
                                )
                                context.fill(path, with: .color(color))
                                
                            case 3: // Small decorative dots
                                let dotSize = CGFloat.random(in: 2...5)
                                let dotRect = CGRect(
                                    x: x + CGFloat.random(in: 0...cellSize - dotSize),
                                    y: y + CGFloat.random(in: 0...cellSize - dotSize),
                                    width: dotSize,
                                    height: dotSize
                                )
                                context.fill(Path(ellipseIn: dotRect), with: .color(color))
                                
                            case 4: // Curved line
                                var path = Path()
                                path.move(to: CGPoint(x: x, y: y + cellSize/2))
                                path.addQuadCurve(
                                    to: CGPoint(x: x + cellSize, y: y + cellSize/2),
                                    control: CGPoint(
                                        x: x + cellSize/2,
                                        y: y + cellSize/2 + CGFloat.random(in: -cellSize...cellSize)
                                    )
                                )
                                context.stroke(
                                    path,
                                    with: .color(color),
                                    lineWidth: CGFloat.random(in: 1...2)
                                )
                                
                            default: break
                            }
                        }
                    }
                    
                    // Add subtle texture overlay
                    context.addFilter(.blur(radius: 1))
                    context.opacity = 0.2
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                // Add sparkling effect
                ForEach(0..<20) { i in
                    Circle()
                        .frame(width: 2, height: 2)
                        .foregroundColor(.white.opacity(Double.random(in: 0.4...0.8)))
                        .position(x: CGFloat.random(in: 0..<geo.size.width),
                                  y: CGFloat.random(in: 0..<geo.size.height))
                        .blur(radius: 1)
                }
            }
        }
        .frame(width: 400, height: 400)
    }
}

PlaygroundPage.current.setLiveView(ArtisticView())
