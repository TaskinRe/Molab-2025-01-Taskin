import SwiftUI
import PlaygroundSupport

struct RandomArtView: View {
    let gridSize = 10
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .cyan, .white, .black]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.black, .purple, .blue]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                Canvas { context, size in
                    let cellSize = min(size.width, size.height) / CGFloat(gridSize)
                    
                    for row in 0..<gridSize {
                        for col in 0..<gridSize {
                            let x = CGFloat(col) * cellSize
                            let y = CGFloat(row) * cellSize
                            let color = colors.randomElement() ?? .white
                            
                            let shapeType = Int.random(in: 0...3)
                            
                            switch shapeType {
                            case 0, 1: // Lines (use stroke)
                                var path = Path()
                                if shapeType == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                    path.addLine(to: CGPoint(x: x + cellSize, y: y + cellSize))
                                } else {
                                    path.move(to: CGPoint(x: x + cellSize, y: y))
                                    path.addLine(to: CGPoint(x: x, y: y + cellSize))
                                }
                                context.stroke(path, with: .color(color), lineWidth: 2)
                                
                            case 2: // Circle (use fill)
                                let rect = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                                context.fill(Path(ellipseIn: rect), with: .color(color))
                                
                            case 3: // Rotated Rectangle
                                let rect = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                                let rotation = Angle.degrees(Double.random(in: 0...360))
                                var path = Path(rect)
                                
                                // Rotate around center
                                let center = CGPoint(x: rect.midX, y: rect.midY)
                                path = path.applying(
                                    CGAffineTransform(translationX: -center.x, y: -center.y)
                                        .rotated(by: rotation.radians)
                                        .translatedBy(x: center.x, y: center.y)
                                )
                                context.fill(path, with: .color(color))
                                
                            default: break
                            }
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .frame(width: 400, height: 400) // Fixed size for playground
    }
}

PlaygroundPage.current.setLiveView(RandomArtView())
