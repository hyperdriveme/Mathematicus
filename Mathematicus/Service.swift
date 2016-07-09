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

private let sharedService = MathematicusService()

class MathematicusService {
	var matricesForDecomposition: [Int : Matrix]
	var matrixDecompositionTasks: [Int : dispatch_block_t]
	var matrixDecompositionResults: [Int : (Matrix, [Complex])]
	var matrixCounter: Int
	var queue: dispatch_queue_t
	
	private init() {
		matricesForDecomposition = [ : ]
		matrixDecompositionTasks = [ : ]
		matrixDecompositionResults = [ : ]
		matrixCounter = 0
		let queueDescriptor = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, 0)
		queue = dispatch_queue_create("Mathematicus background computation service", queueDescriptor)
	}
	
	static let sharedInstance = sharedService
	
	func registerMatrixForDecomposition(matrixForDecomposition mat: Matrix) -> MatrixDecompositionIdentifier {
		matrixCounter += 1
		matricesForDecomposition[matrixCounter] = mat
		let identifier = matrixCounter
		let task = dispatch_block_create(DISPATCH_BLOCK_ENFORCE_QOS_CLASS, {
			self.matrixDecompositionResults[identifier] = mat.eigendecomposition()
		})
		matrixDecompositionTasks[matrixCounter] = task
		dispatch_async(queue, task)
		return matrixCounter
	}
}