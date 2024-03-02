import Foundation

/// A Lab value in the CIELab color space
struct Lab {
	
	// MARK: Properties
	
	var l: Double
	var a: Double
	var b: Double
	
	// MARK: Conversions
	
	func xyz() -> XYZ {
    #if canImport(Accelerate)
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
      return accl_xyz()
    }
    #endif
		let k = 24389.0/27.0
		let e = 216.0/24389.0
		
		let fy = (l + 16)/116
		let fx = fy + (a/500)
		let fz = fy - (b/200)
		
		let x = pow(fx, 3) > e ? pow(fx, 3) : (116 * fx - 16)/k
		let y = l > k * e      ? pow(fy, 3) : l/k
		let z = pow(fz, 3) > e ? pow(fz, 3) : (116 * fz - 16)/k
		
		let d65WhitePoint = (
			x: 0.3127/0.3290,
			y: 1.00000,
			z: (1.0 - 0.3127 - 0.3290) / 0.3290
		)
		
		return XYZ(
			x: x * d65WhitePoint.x,
			y: y * d65WhitePoint.y,
			z: z * d65WhitePoint.z
		)
	}
	
	// MARK: Sugar
	
	func p3() -> P3 {
		xyz().p3()
	}
}

#if canImport(Accelerate)
import Accelerate

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Lab {
  static let k = vDSP.divide([24389.0], 27.0).first!
  static let e = vDSP.divide([216.0], 24389.0).first!
  static let limit = vDSP.multiply(Self.k, [Self.e]).first!
  
  func accl_xyz() -> XYZ {
    let fy = vDSP.divide([vDSP.sum([l, 16])], 116)
    let fx = vDSP.sum([fy.first!, vDSP.divide([a], 500).first!])
    let fz = vDSP.sum([fy.first!, vDSP.multiply(-1, vDSP.divide([b], 200)).first!])
    
    let x = vForce.pow(bases: [fx], exponents: [3]).first! > Self.e ?
    vForce.pow(bases: [fx], exponents: [3]).first! :
    vDSP.divide([vDSP.multiply(116, [fx]).first! - 16], Self.k).first!
    
    let y = l > Self.limit ?
    vForce.pow(bases: fy, exponents: [3]).first! :
    vDSP.divide([l], Self.k).first!
    
    let z = vForce.pow(bases: [fz], exponents: [3]).first! > Self.e ?
    vForce.pow(bases: [fz], exponents: [3]).first! :
    vDSP.divide([vDSP.multiply(116, [fz]).first! - 16], Self.k).first!
    
    let d65WhitePoint = (
      x: vDSP.divide([0.3127],0.3290).first!,
      y: 1.00000,
      z: vDSP.divide([vDSP.sum([1.0,-0.3127, -0.3290])], 0.3290).first!
    )
    
    return XYZ(
      x: vDSP.multiply(d65WhitePoint.x, [x]).first!,
      y: vDSP.multiply(d65WhitePoint.y, [y]).first!,
      z: vDSP.multiply(d65WhitePoint.z, [z]).first!
    )
  }
}
#endif
