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