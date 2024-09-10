#if canImport(UIKit)
import UIKit

public extension UIColor {
    
    convenience init(_ p3: P3, alpha: Double = 1.0) {
        self.init(displayP3Red: p3.r, green: p3.g, blue: p3.b, alpha: alpha)
    }
    
    convenience init(_ xyzConvertable: XYZConvertable, alpha: Double = 1.0) {
        self.init(xyzConvertable.p3, alpha: alpha)
    }

}
#endif
