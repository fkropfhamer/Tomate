import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let top = CGPoint(x: rect.minX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.midY)
        
        path.move(to: top)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.addLine(to: top)
        path.closeSubpath()
        
        return path
    }
}


struct StartButton: View {
    var color: Color
    
    var body: some View {
        Triangle()
            .fill(color)
            .overlay(
                Triangle()
                    .stroke(color, style: StrokeStyle(lineWidth: 15, lineJoin: .round))
            )
            .frame(width: 50, height: 60)
    }
}

#Preview {
    StartButton(color: Color.blue)
}
