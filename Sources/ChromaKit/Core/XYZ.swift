import Foundation

/// An XYZ value in the XYZ color space
public struct XYZ: XYZConvertable {
	
	// MARK: Properties
	
    public var x: Double
    public var y: Double
    public var z: Double
    
    // MARK: Init
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
	
	// MARK: Conversions
	
    public var p3: P3 {
        #if canImport(Accelerate)
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
          return accl_p3()
        }
        #endif
		let xyzToLinearP3 = ColorMatrix(
			x: (446124/178915, -333277/357830,   -72051/178915),
			y: (-14852/17905,    63121/35810,       423/17905),
			z: ( 11844/330415,  -50337/660830,   316169/330415)
		)
		
		let (r, g, b) = xyzToLinearP3.dotProduct((x, y, z))
		return P3(r: r, g: g, b: b).gammaCorrected()
	}
    
    public var xyz: XYZ { self }
}

/// A color that can be converted to XYZ color space
public protocol XYZConvertable {
    var xyz: XYZ { get }
}

public extension XYZConvertable {
    var p3: P3 { xyz.p3 }
}

#if canImport(Accelerate)
import Accelerate

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension XYZ {
  static let xRow: ColorComponents = (
    vDSP.divide([446124], 178915).first!,
    vDSP.divide([-333277], 357830).first!,
    vDSP.divide([-72051], 178915).first!
  )
  
  static let yRow: ColorComponents = (
    vDSP.divide([-14852], 17905).first!,
    vDSP.divide([63121], 35810).first!,
    vDSP.divide([423], 17905).first!
  )
  
  static let zRow: ColorComponents = (
    vDSP.divide([11844], 330415).first!,
    vDSP.divide([-50337], 660830).first!,
    vDSP.divide([316169], 330415).first!
  )
  
  static let colorMatrix = ColorMatrix(x: xRow, y: yRow, z: zRow)
  
  func accl_p3() -> P3 {
    let result = Self.colorMatrix.accl_dotProduct((x,y,z))
    
    return P3(r: result.0, g: result.1, b: result.2).gammaCorrected()
  }
}
#endif
