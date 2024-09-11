import Foundation

/// An LCH value in the Oklch color space
public struct Oklch: XYZConvertable {
	
	// MARK: Properties
	
    public var l: Double
    public var c: Double
    public var h: Double
    
    // MARK: Init
    
    public init(l: Double, c: Double, h: Double) {
        self.l = l
        self.c = c
        self.h = h
    }
	
	// MARK: Conversions
	
    public var oklab: Oklab {
		Oklab(
			l: l,
			a: cos(h * .pi / 180) * c,
			b: sin(h * .pi / 180) * c
		)
	}
	
	// MARK: Sugar
	
    public var xyz: XYZ { oklab.xyz }
}
