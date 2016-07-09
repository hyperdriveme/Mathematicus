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

extension Polynomial where Field: Continuum {
	func evaluateDerivative(at x: Field) -> Field {
		var rst = Field.zero
		var run = Field.identity
		for i in 1...self.maxexp {
			if let c = self.coffcient[i] {
				let term = c * Field.realNumber(Double(i)) * run
				rst = rst + term
			}
			run = run * x
		}
		return rst
	}
	
	var derivative: Polynomial<Field> {
		var coff: [Int : Field] = [ : ]
		for i in 1..<self.maxexp {
			if let c = self.coffcient[i] {
				coff[i - 1] = c * Field.realNumber(Double(i))
			}
		}
		return Polynomial<Field>(coffcient: coff, maxexp: self.maxexp - 1)
	}
}