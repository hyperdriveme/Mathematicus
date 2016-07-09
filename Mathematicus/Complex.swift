// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// 	specific language governing permissions and limitations
// under the License.
import Foundation

public struct Complex {
	public let real, imaginary: Double
	
	public init(fromPolarAngle a: Double, polarDistance d: Double) {
		self.real = d * cos(a)
		self.imaginary = d * sin(a)
	}
	
	public init(fromOrthonormalReal r: Double, imaginary i: Double) {
		self.real = r
		self.imaginary = i
	}
	
	public init(realNumber r: Double) {
		self.real = r
		self.imaginary = 0
	}
	
	public init(pureImaginaryNumber i: Double) {
		self.real = 0
		self.imaginary = i
	}
	
	public var absolute: Double {
		return sqrt(real * real + imaginary * imaginary)
	}
}

public func +(lhs: Complex, rhs: Complex) -> Complex {
	return Complex(fromOrthonormalReal: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
}

public func -(lhs: Complex, rhs: Complex) -> Complex {
	return Complex(fromOrthonormalReal: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
}

public func *(lhs: Complex, rhs: Complex) -> Complex {
	let r = lhs.real * rhs.real - lhs.imaginary * rhs.imaginary
	let i = lhs.imaginary * rhs.real + lhs.real * rhs.imaginary
	return Complex(fromOrthonormalReal: r, imaginary: i)
}

public func /(lhs: Complex, rhs: Complex) -> Complex {
	let r = lhs.real * rhs.real + lhs.imaginary * rhs.imaginary
	let i = lhs.imaginary * rhs.real - lhs.real * rhs.imaginary
	let ns = rhs.absolute * rhs.absolute
	return Complex(fromOrthonormalReal: r / ns, imaginary: i / ns)
}

public prefix func -(x: Complex) -> Complex {
	return Complex(fromOrthonormalReal: -x.real, imaginary: -x.imaginary)
}

public func ==(lhs: Complex, rhs: Complex) -> Bool {
	return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
}

extension Complex: Number {
	public static let identity = Complex(realNumber: 1.0)
	public static let zero = Complex(realNumber: 0.0)
	
	public static func realNumber(d: Double) -> Complex {
		return Complex(realNumber: d)
	}
}

extension Complex: AlgebraicComplete {
	
}

extension Complex: NewtonMethodAppliable {
	public static func randomElement() -> Complex {
		let r = Double.randomElement()
		let i = Double.randomElement()
		return Complex(fromOrthonormalReal: r, imaginary: i)
	}
}

extension Complex: Continuum {
	public func scale(at x: Double) -> Complex {
		return Complex(fromOrthonormalReal: self.real * x, imaginary: self.imaginary * x)
	}
}

extension Complex: ComplexLikeSystem {
	public var conjugate: Complex {
		return Complex(fromOrthonormalReal: self.real, imaginary: -self.imaginary)
	}
}