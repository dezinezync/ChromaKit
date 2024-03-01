import Foundation

/// An XYZ value in the XYZ color space
struct XYZ {
	
	// MARK: Properties
	
	var x: Double
	var y: Double
	var z: Double
	
	// MARK: Conversions
	
	func p3() -> P3 {
		let xyzToLinearP3 = ColorMatrix(
			x: (446124/178915, -333277/357830,   -72051/178915),
			y: (-14852/17905,    63121/35810,       423/17905),
			z: ( 11844/330415,  -50337/660830,   316169/330415)
		)
		
		let (r, g, b) = xyzToLinearP3.dotProduct((x, y, z))
		return P3(r: r, g: g, b: b).gammaCorrected()
	}
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
