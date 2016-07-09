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

public struct Vector<Field: Number> {
	var contents: [Field]
}

public extension Vector {
	public func vectorizeOperation(o: Field -> Field) -> (Vector<Field> -> Vector<Field>) {
		return {
			let t = $0.contents.map(o)
			return Vector<Field>(contents: t)
		}
	}
	
	public func vectorizeOperation(o: (Field, Field) -> Field) -> ((Vector<Field>, Vector<Field>) -> Vector<Field>) {
		return {v1, v2 in
			let t = zip(v1.contents, v2.contents)
			let r = t.map(o)
			return Vector<Field>(contents: r)
		}
	}
}

public func +<U>(lhs: Vector<U>, rhs: Vector<U>) -> Vector<U> {
	let t = zip(lhs.contents, rhs.contents)
		.map {
			$0.0 + $0.1
	}
	return Vector<U>(contents: t)
}

public func -<U>(lhs: Vector<U>, rhs: Vector<U>) -> Vector<U> {
	let t = zip(lhs.contents, rhs.contents)
		.map {
			$0.0 - $0.1
	}
	return Vector<U>(contents: t)
}

public func *<U: ComplexLikeSystem>(lhs: Vector<U>, rhs: Vector<U>) -> U {
	let t = zip(lhs.contents, rhs.contents)
	return t.map {$0.0 * ($0.1).conjugate}.reduce(U.zero, combine: +)
}

public extension Vector {
	public var norm: Double {
		let t = self.contents.map { $0.absolute }
			.map {
				$0 * $0
		}
		.reduce(0.0, combine: +)
		return sqrt(t)
	}
}

public extension Vector where Field: Continuum {
	public func normalize() -> Vector<Field> {
		let normInverse = 1.0 / self.norm
		let newcontent = self.contents.map{ $0.scale(at: normInverse) }
		return Vector<Field>(contents: newcontent)
	}
	
	public func scale(at x: Double) -> Vector<Field> {
		let newcontent = self.contents.map{ $0.scale(at: x) }
		return Vector<Field>(contents: newcontent)
	}
	
	public func scale(at x: Field) -> Vector<Field> {
		let newcontent = self.contents.map{ $0 * x }
		return Vector<Field>(contents: newcontent)
	}
}