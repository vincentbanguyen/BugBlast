import RealityKit
import UIKit
import SwiftUI


extension SIMD3 where Scalar == Float {
    
    static func spawnPoint(from: SIMD3<Float>, lowerRadius: Float, upperRadius: Float) -> SIMD3<Float> {
        let t = Int.random(in: 0...2)
        
        switch t {
        case 0:
            let x = Float.random(in: lowerRadius..<upperRadius) * (Bool.random() ? 1 : -1)
            let y = Float.random(in: -upperRadius..<upperRadius)
            let z = Float.random(in: -upperRadius..<upperRadius)
            let num = SIMD3<Float>(x,y,z)
            return num
        case 1:
            let z = Float.random(in: lowerRadius..<upperRadius) * (Bool.random() ? 1 : -1)
            let y = Float.random(in: -upperRadius..<upperRadius)
            let x = Float.random(in: -upperRadius..<upperRadius)
            let num = SIMD3<Float>(x,y,z)
            return num
        case 2:
            let y = Float.random(in: lowerRadius..<upperRadius) * (Bool.random() ? 1 : -1)
            let x = Float.random(in: -upperRadius..<upperRadius)
            let z = Float.random(in: -upperRadius..<upperRadius)
            let num = SIMD3<Float>(x,y,z)
            return num
        default:
            let y = Float.random(in: lowerRadius..<upperRadius) * (Bool.random() ? 1 : -1)
            let x = Float.random(in: -upperRadius..<upperRadius)
            let z = Float.random(in: -upperRadius..<upperRadius)
            let num = SIMD3<Float>(x,y,z)
            return num
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


extension UIColor {
    static func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension float4x4 {
    var forward: SIMD3<Float> {
        normalize(SIMD3<Float>(-columns.2.x, -columns.2.y, -columns.2.z))
    }
}

extension View {
    
  public dynamic func reverseMask<Mask: View>(
    alignment: Alignment = .center,
    @ViewBuilder _ mask: () -> Mask
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          mask()
            .blendMode(.destinationOut)
        }
    }
  }
}
