import SwiftUI

struct ControlBoard: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: rect.maxX / 3, y: 0),
                      control1: CGPoint(x: rect.maxX / 8, y: -50.0),
                      control2: CGPoint(x: rect.maxX / 8, y: -50.0))
        path.addCurve(to: CGPoint(x: rect.maxX * 2 / 3 , y: 0),
                      control1: CGPoint(x: rect.maxX / 2, y: 50.0),
                      control2: CGPoint(x: rect.maxX / 2, y: 50.0))
        path.addCurve(to: CGPoint(x: rect.maxX, y: 0),
                      control1: CGPoint(x: rect.maxX / 8 * 7, y: -50.0),
                      control2: CGPoint(x: rect.maxX / 8 * 7, y: -50.0))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
}
