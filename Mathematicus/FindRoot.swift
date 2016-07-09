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

public extension Polynomial where Field: NewtonMethodAppliable {
	func findRootTheNewtonWay(at x: Field, eps: Double = 1e-10, maxiumIteration: Int = 10000) -> Field? {
		var y = x
		var eval: Field = self.evaluate(at: x)
		for _ in 0..<maxiumIteration {
			y = y - eval / self.evaluateDerivative(at: y)
			eval = evaluate(at: y)
			if eval.absolute < eps {
				return y
			}
		}
		return nil
	}
	
	func reduce(atRoot x: Field, eps: Double = 1e-10) -> (Polynomial<Field>, Int) {
		var count = 0
		var poly = self
		while poly.evaluate(at: x).absolute < eps {
			for i in (0..<poly.maxexp).reverse() {
				if let c = poly.coffcient[i + 1] {
					if poly.coffcient[i] != nil {
						poly.coffcient[i] = c + poly.coffcient[i]!
					} else {
						poly.coffcient[i] = c
					}
				}
			}
			var newcoff: [Int : Field] = [ : ]
			for i in 0..<poly.maxexp {
				newcoff[i] = poly.coffcient[i + 1]
			}
			poly.coffcient = newcoff
			poly.maxexp -= 1
			count += 1
		}
		return (poly, count)
	}
}

extension Polynomial {
	func exactReduce(atRoot x: Field) -> (Polynomial<Field>, Int) {
		var count = 0
		var poly = self
		while poly.evaluate(at: x) == Field.zero {
			for i in (0..<poly.maxexp).reverse() {
				if let c = poly.coffcient[i + 1] {
					if poly.coffcient[i] != nil {
						poly.coffcient[i] = c + poly.coffcient[i]!
					} else {
						poly.coffcient[i] = c
					}
				}
			}
			var newcoff: [Int : Field] = [ : ]
			for i in 0..<poly.maxexp {
				newcoff[i] = poly.coffcient[i + 1]
			}
			poly.coffcient = newcoff
			poly.maxexp -= 1
			count += 1
		}
		return (poly, count)
	}
}

extension Polynomial where Field: AlgebraicComplete, Field: NewtonMethodAppliable {
	func findAllRootsTheNewtonWay(eps: Double = 1e-8) -> [(Field, Int)] {
		var count = 0
		var poly = self
		var rst: [(Field, Int)] = []
		while count < self.maxexp {
			let start = Field.randomElement()
			let root = poly.findRootTheNewtonWay(at: start, eps: eps * 1e-10)
			let (q, degenerate) = poly.reduce(atRoot: root!, eps: eps)
			poly = q
			count += degenerate
			rst.append((root!, degenerate))
		}
		print(rst)
		return rst
	}
}

public extension Polynomial {
	public static func rootFactor(root x: Field, normal: Field) -> Polynomial<Field> {
		guard normal != Field.zero else {
			return Polynomial<Field>.zeroPolynomial()
		}
		return Polynomial<Field>(coffcient: [1 : normal, 0 : (-x)*normal], maxexp: 1)
	}
}