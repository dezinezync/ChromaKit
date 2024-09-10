import Foundation

/// A 3-element tuple used to represent a set of color components, such as `rgb`,` lab`, `lch`, and so on.
typealias ColorComponents = (Double, Double, Double)

/// A 3x3 matrix used to perform color transformations
struct ColorMatrix {
	var x: ColorComponents
	var y: ColorComponents
	var z: ColorComponents
}

extension ColorMatrix {
	func dotProduct(_ components: ColorComponents) -> ColorComponents {
        #if canImport(simd)
        return accl_dotProduct(components)
        #else
		return (
			components.0 * x.0 + components.1 * x.1 + components.2 * x.2,
			components.0 * y.0 + components.1 * y.1 + components.2 * y.2,
			components.0 * z.0 + components.1 * z.1 + components.2 * z.2
		)
        #endif
	}
}

#if canImport(simd)
import simd
import Accelerate

extension ColorMatrix {
  func accl_dotProduct(_ components: ColorComponents) -> ColorComponents {
    let componentsMatrix = SIMD3<Double>(
      components.0,
      components.1,
      components.2
    )
    
    let multiplicatorsMatrix = double3x3([
      SIMD3(x.0, x.1, x.2),
      SIMD3(y.0, y.1, y.2),
      SIMD3(z.0, z.1, z.2)
    ])
    
    let result = componentsMatrix * multiplicatorsMatrix
    
    return (result.x, result.y, result.z)
    /*
     * produces incorrect results in comparison to
     * existing implementations using standard swift arithmetic
     *
     var result: [Double] = Array(repeating: 0, count: 3)
     
     result[0] = vDSP.sum(vDSP.multiply(components.0, [x.0, x.1, x.2]))
     result[1] = vDSP.sum(vDSP.multiply(components.1, [y.0, y.1, y.2]))
     result[2] = vDSP.sum(vDSP.multiply(components.2, [z.0, z.1, z.2]))
     
     return (
       result[0],
       result[1],
       result[2]
     )
     */
  }
}
#endif
