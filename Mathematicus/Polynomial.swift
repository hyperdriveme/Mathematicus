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

public struct Polynomial<Field: Number> {
	public var coffcient: [Int : Field]
	public internal(set) var maxexp: Int
	
	public static func identityPolynomial() -> Polynomial<Field> {
		return Polynomial<Field>(coffcient: [1 : Field.identity], maxexp: 1)
	}
	
	public static func zeroPolynomial() -> Polynomial<Field> {
		return Polynomial<Field>(coffcient: [0 : Field.zero], maxexp: 0)
	}
	
	public static func constantPolynomial(c c: Field) -> Polynomial<Field> {
		return Polynomial<Field>(coffcient: [0 : c], maxexp: 0)
	}
	
	public static func findOrder<T>(of p: [Int : T], maxiumTrial: Int) -> Int {
		for i in (1...maxiumTrial).reverse() {
			if p[i] != nil {
				return i
			}
		}
		return 0
	}
}

public func +<U>(lhs: Polynomial<U>, rhs: Polynomial<U>) -> Polynomial<U> {
	let e = max(lhs.maxexp, rhs.maxexp)
	var coff: [Int : U] = [ : ]
	for i in 0...e {
		if lhs.coffcient[i] != nil {
			coff[i] = lhs.coffcient[i]!
			if rhs.coffcient[i] != nil {
				coff[i] = rhs.coffcient[i]! + coff[i]!
			}
		} else {
			coff[i] = rhs.coffcient[i]
		}
		if let j = coff[i] {
			if j == U.zero {
				coff[i] = nil
			}
		}
	}
	var rst = Polynomial<U>.identityPolynomial()
	rst.coffcient = coff
	rst.maxexp = Polynomial<U>.findOrder(of: coff, maxiumTrial: e)
	return rst
}

public func *<U>(lhs: U, rhs: Polynomial<U>) -> Polynomial<U> {
	if lhs == U.zero {
		return Polynomial<U>.zeroPolynomial()
	}
	var newcoff = rhs.coffcient
	for i in 0...rhs.maxexp {
		if let c = newcoff[i] {
			newcoff[i] = c * lhs
		}
	}
	return Polynomial<U>(coffcient: newcoff, maxexp: rhs.maxexp)
}

public func *<U>(lhs: Polynomial<U>, rhs: U) -> Polynomial<U> {
	return rhs * lhs
}

public func *<U>(lhs: Polynomial<U>, rhs: Polynomial<U>) -> Polynomial<U> {
	var rst = Polynomial<U>.zeroPolynomial()
	for (i, c) in lhs.coffcient {
		var newcoff: [Int : U] = [ : ]
		for (j, m) in rhs.coffcient {
			newcoff[i + j] = c * m
		}
		let newpoly = Polynomial<U>(coffcient: newcoff, maxexp: rhs.maxexp + i)
		rst = rst + newpoly
	}
	return rst
}

public func -<U>(lhs: Polynomial<U>, rhs: Polynomial<U>) -> Polynomial<U> {
	let minusOne = -U.identity
	let s = minusOne * rhs
	return lhs + s
}

public extension Polynomial {
	func evaluate(at x: Field) -> Field {
		var rst = Field.zero
		var run = Field.identity
		for i in 0...self.maxexp {
			if let c = self.coffcient[i] {
				rst = rst + c * run
			}
			run = run * x
		}
		return rst
	}
}

public extension Polynomial {
	func isZeroPolynomial() -> Bool {
		let n = self.maxexp
		var s: [Field] = [Field.randomElement()]
		for _ in 0..<n {
			var flag = true
			var new: Field = Field.randomElement()
			while flag {
				flag = s.map { $0 == new }
					.reduce(false) {
						$0 || $1
				}
				new = Field.randomElement()
			}
			s.append(new)
		}
		
		let test = s.map { self.evaluate(at: $0) }.map { $0 == Field.zero }
			.reduce(true) {
				$0 && $1
		}
		return test
	}
}