import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, visionOS 1, *)
public extension Color {
    
    init(_ p3: P3, opacity: Double = 1.0) {
        self.init(.displayP3, red: p3.r, green: p3.g, blue: p3.b, opacity: opacity)
    }
    
    init(_ xyzConvertable: XYZConvertable, opacity: Double = 1.0) {
        self.init(xyzConvertable.p3, opacity: opacity)
    }
    
}
