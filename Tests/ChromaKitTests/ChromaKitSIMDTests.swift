//
//  ChromaKitACCLTests.swift
//  
//
//  Created by Nikhil Nigade on 01/03/24.
//

#if canImport(Accelerate)
import Accelerate
import XCTest
@testable import ChromaKit

/// For running the following tests and validating correctly
/// disable the `accl_method` calls in the main functions
/// of each Struct. 
final class ChromaKitACCLTests: XCTestCase {
  fileprivate let standardMatrix = ColorMatrix(x: (0.5, 1, 1), y: (0.25, 1, 0), z: (0.125, 0, 1))
  fileprivate let standardComponent: ColorComponents = (0.5, 0.5, 0.5)
  
  func testColorMatrix() throws {
    let matrix = standardMatrix
    let standardResult = matrix.dotProduct(standardComponent)
    let ACCLResult = matrix.accl_dotProduct(standardComponent)
    
    XCTAssertEqual(standardResult.0, ACCLResult.0, accuracy: 0.001)
    XCTAssertEqual(standardResult.1, ACCLResult.1, accuracy: 0.001)
    XCTAssertEqual(standardResult.2, ACCLResult.2, accuracy: 0.001)
  }
  
  func testColorMatrixStandardPerf() throws {
    let matrix = standardMatrix
    measure {
      for _ in 0..<10000 {
        let component: ColorComponents = (Double.random(in: 0...1), Double.random(in: 0...1), Double.random(in: 0...1))
        let _ = matrix.dotProduct(component)
      }
    }
  }
  
  func testColorMatrixACCLPerf() throws {
    let matrix = standardMatrix
    measure {
      for _ in 0..<10000 {
        let component: ColorComponents = (Double.random(in: 0...1), Double.random(in: 0...1), Double.random(in: 0...1))
        let _ = matrix.accl_dotProduct(component)
      }
    }
  }
  
  func testLAB() throws {
    let lab = Lab(l: 350, a: 80, b: 80)
    let standardResult = lab.xyz()
    let ACCLResult = lab.accl_xyz()
    
    XCTAssertEqual(standardResult.x, ACCLResult.x, accuracy: 0.0001)
    XCTAssertEqual(standardResult.y, ACCLResult.y, accuracy: 0.0001)
    XCTAssertEqual(standardResult.z, ACCLResult.z, accuracy: 0.0001)
  }
  
  func testLABStandardPerf() {
    measure {
      for _ in 0..<10000 {
        let lab = Lab(l: Double.random(in: 0...360), a: Double.random(in: 0...100), b: Double.random(in: 0...100))
        let _ = lab.xyz()
      }
    }
  }
  
  func testLABACCLPerf() {
    measure {
      for _ in 0..<10000 {
        let lab = Lab(l: Double.random(in: 0...360), a: Double.random(in: 0...100), b: Double.random(in: 0...100))
        let _ = lab.accl_xyz()
      }
    }
  }
  
  func testXYZ() throws {
    let xyz = XYZ(x: 255, y: 125, z: 64)
    let standardResult = xyz.p3()
    let ACCLResult = xyz.accl_p3()
    
    XCTAssertEqual(standardResult.r, ACCLResult.r, accuracy: 0.0001)
    XCTAssertEqual(standardResult.g, ACCLResult.g, accuracy: 0.0001)
    XCTAssertEqual(standardResult.b, ACCLResult.b, accuracy: 0.0001)
  }
  
  func testXYZStandardPerf() {
    measure {
      for _ in 0..<10000 {
        let lab = XYZ(x: Double.random(in: 0...360), y: Double.random(in: 0...100), z: Double.random(in: 0...100))
        let _ = lab.p3()
      }
    }
  }
  
  func testXYZACCLPerf() {
    measure {
      for _ in 0..<10000 {
        let lab = XYZ(x: Double.random(in: 0...360), y: Double.random(in: 0...100), z: Double.random(in: 0...100))
        let _ = lab.p3()
      }
    }
  }
}

#endif
