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

public struct Quaternion {
	public let w, x, y, z: Double
	
	public init(fromOrderedListForm o: [Double]) {
		self.w = o[0]
		self.x = o[1]
		self.y = o[2]
		self.z = o[3]
	}
	
	public init(fromExplictFormW w: Double, x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	}
	
	public init(fromVectorForm v: Vector<Double>) {
		let o = v.contents
		self.w = o[0]
		self.x = o[1]
		self.y = o[2]
		self.z = o[3]
	}
	
	public init(fromVector v: Vector<Double>, andAngle a: Double) {
		self.w = cos(a / 2)
		let s = sin(a / 2)
		let o = v.contents
		self.x = s * o[0]
		self.y = s * o[1]
		self.z = s * o[2]
	}
	
	public init(fromEulerAngleX X: Double, Y: Double, Z: Double) {
		let sx = sin(X / 2)
		let sy = sin(Y / 2)
		let sz = sin(Z / 2)
		let cx = cos(X / 2)
		let cy = cos(Y / 2)
		let cz = cos(Z / 2)
		
		self.x = sy*sz*cx+cy*cz*sx
		self.y = sy*cz*cx+cy*sz*sx
		self.z = cy*sz*cx-sy*cz*sx
		self.w = cy*cz*cx-sy*sz*sx
	}
}

public func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
	return Quaternion(fromExplictFormW: lhs.w + rhs.w, x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

public prefix func -(x: Quaternion) -> Quaternion {
	return Quaternion(fromExplictFormW: -x.w, x: -x.x, y: -x.y, z: -x.z)
}

public func -(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
	return lhs + (-rhs)
}

public func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
	let w1 = lhs.w
	let w2 = rhs.w
	let x1 = lhs.x
	let x2 = rhs.x
	let y1 = lhs.y
	let y2 = rhs.y
	let z1 = lhs.z
	let z2 = rhs.z
	
	let w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2
	let x = w1 * x2 + w2 * x1 + y1 * z2 - y2 * z1
	let y = w1 * y2 + w2 * y1 + z1 * x2 - z2 * x1
	let z = w1 * z2 + w2 * z1 + x1 * y2 - x2 * y1
	
	return Quaternion(fromExplictFormW: w, x: x, y: y, z: z)
}

public func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
	let a = lhs.w == rhs.w && lhs.x == rhs.x
	let b = lhs.y == rhs.y && lhs.z == rhs.z
	return a && b
}

public extension Quaternion {
	public var absolute: Double {
		let sd = w*w + x*x + y*y + z*z
		return sqrt(sd)
	}
	
	public var conjugate: Quaternion {
		return Quaternion(fromExplictFormW: w, x: -x, y: -y, z: -z)
	}
	
	public func scale(at x: Double) -> Quaternion {
		let a = self.w * x
		let b = self.x * x
		let c = self.y * x
		let d = self.z * x
		return Quaternion(fromExplictFormW: a, x: b, y: c, z: d)
	}
	
	public var inverse: Quaternion {
		let n = self.absolute
		let nd = n * n
		let s = 1.0 / nd
		let cj = self.conjugate
		return cj.scale(at: s)
	}
}

public extension Quaternion {
	public static func realNumber(d: Double) -> Quaternion {
		return Quaternion(fromExplictFormW: d, x: 0, y: 0, z: 0)
	}
}

public extension Quaternion {
	public static var zero = Quaternion.realNumber(0)
	
	public static var identity = Quaternion.realNumber(1)
	
	public static func randomElement() -> Quaternion {
		let w = Double.randomElement()
		let x = Double.randomElement()
		let y = Double.randomElement()
		let z = Double.randomElement()
		return Quaternion(fromExplictFormW: w, x: x, y: y, z: z)
	}
}

extension Quaternion: Number {
	
}

extension Quaternion: Continuum {
	
}

extension Quaternion: AlgebraicComplete {
	
}

extension Quaternion: ComplexLikeSystem {
	
}