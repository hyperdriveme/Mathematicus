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

extension Double: Number {
	public static let identity = 1.0
	public static let zero = 0.0
	
	public static func randomElement() -> Double {
		let u = arc4random()
		let d = Double(u) / Double(UINT32_MAX)
		return d * 1000
	}
	
	public var absolute: Double {
		return fabs(self)
	}
}

extension Double: NewtonMethodAppliable {
	
}

extension Double: Continuum {
	public static func realNumber(d: Double) -> Double {
		return d
	}
	
	public func scale(at x: Double) -> Double {
		return self*x
	}
}

extension Double: ComplexLikeSystem {
	public var conjugate: Double {
		return self
	}
}