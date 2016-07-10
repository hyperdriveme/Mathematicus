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

public protocol Number: Equatable {
	func +(lhs: Self, rhs: Self) -> Self
	func *(lhs: Self, rhs: Self) -> Self
	func -(lhs: Self, rhs: Self) -> Self
	static var identity: Self { get }
	static var zero: Self { get }
	prefix func -(x: Self) -> Self
	static func randomElement() -> Self
	var absolute: Double { get }
}

public protocol AlgebraicComplete: Continuum {
	
}

public protocol NewtonMethodAppliable: Continuum {
	func /(lhs: Self, rhs: Self) -> Self
}
