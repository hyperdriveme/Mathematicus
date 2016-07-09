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

struct OrdinaryDifferentialEquation<Field: Continuum> {
	private let equations: Vector<Field> -> Vector<Field>
	private let initial: Vector<Field>
	private let dimension: Int
	
	init(dimension: Int, initial: Vector<Field>, equations: Vector<Field> -> Vector<Field>) {
		guard initial.contents.count == dimension else {
			fatalError("Not capatable initial values")
		}
		self.dimension = dimension
		self.equations = equations
		self.initial = initial
	}
	
	func solve(terminatingTime t: Double, step: Double) -> [Vector<Field>] {
		var solution: [Vector<Field>] = []
		var T = 0.0
		var last = initial
		while T <= t {
			T += step
			let k1 = equations(last)
			let k2 = equations(last + k1.scale(at: step / 2.0))
			let k3 = equations(last + k2.scale(at: step / 2.0))
			let k4 = equations(last + k3.scale(at: step))
			last = k1.scale(at: step / 6.0) + k2.scale(at: step / 3.0) + k3.scale(at: step / 3.0) + k4.scale(at: step / 6.0)
			solution.append(last)
		}
		return solution
	}
}