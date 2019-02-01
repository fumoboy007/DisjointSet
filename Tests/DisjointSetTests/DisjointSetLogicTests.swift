// Copyright © 2019 Darren Mo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the “Software”), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import XCTest
@testable import DisjointSet

final class DisjointSetLogicTests: XCTestCase {
   func testEmpty() {
      let disjointSet = DisjointSet<Int>()

      assertDisjointSet(disjointSet,
                        containsSubsets: [],
                        doesNotContain: 0)
   }

   func testInsertSingleMemberNoUnion() {
      var disjointSet = DisjointSet<Int>()
      disjointSet.insert(1, unioningWith: [])

      assertDisjointSet(disjointSet,
                        containsSubsets: [[1]],
                        doesNotContain: 0)
   }

   func testInsertSingleMemberWithUnion() {
      var disjointSet = DisjointSet<Int>()
      disjointSet.insert(1, unioningWith: [0, 2])

      assertDisjointSet(disjointSet,
                        containsSubsets: [[1]],
                        doesNotContain: 0, 2)
   }

   func testInsertSingleMemberUnioningSelf() {
      var disjointSet = DisjointSet<Int>()
      disjointSet.insert(1, unioningWith: [1])

      assertDisjointSet(disjointSet,
                        containsSubsets: [[1]],
                        doesNotContain: 0)
   }

   func testInsertMultipleMembersNoUnion() {
      var disjointSet = DisjointSet<Int>()
      disjointSet.insert(1, unioningWith: [])
      disjointSet.insert(2, unioningWith: [3])

      assertDisjointSet(disjointSet,
                        containsSubsets: [[1], [2]],
                        doesNotContain: 0)
   }

   func testInsertMultipleMembersWithUnion() {
      var disjointSet = DisjointSet<Int>()
      disjointSet.insert(1, unioningWith: [])
      disjointSet.insert(2, unioningWith: [1])

      assertDisjointSet(disjointSet,
                        containsSubsets: [[1, 2]],
                        doesNotContain: 0)
   }

   func testInsertMultipleMembersWithDoubleUnion() {
      var disjointSet = DisjointSet<Int>()
      disjointSet.insert(1, unioningWith: [])
      disjointSet.insert(3, unioningWith: [])
      disjointSet.insert(2, unioningWith: [1, 3])

      assertDisjointSet(disjointSet,
                        containsSubsets: [[1, 2, 3]],
                        doesNotContain: 0)
   }

   func testValueTypeSemantics() {
      var disjointSet = DisjointSet<Int>()
      disjointSet.insert(1, unioningWith: [])
      disjointSet.insert(3, unioningWith: [])

      let copy = disjointSet
      disjointSet.insert(2, unioningWith: [1, 3])

      assertDisjointSet(disjointSet,
                        containsSubsets: [[1, 2, 3]],
                        doesNotContain: 0)
      assertDisjointSet(copy,
                        containsSubsets: [[1], [3]],
                        doesNotContain: 2)
   }

   private func assertDisjointSet(_ disjointSet: DisjointSet<Int>,
                                  containsSubsets expectedSubsets: Set<Set<Int>>,
                                  doesNotContain unexpectedValues: Int...) {
      for unexpectedValue in unexpectedValues {
         XCTAssertNil(disjointSet.subset(containing: unexpectedValue))
      }

      for expectedSubset in expectedSubsets {
         for value in expectedSubset {
            XCTAssertEqual(disjointSet.subset(containing: value), expectedSubset)
         }
      }

      XCTAssertEqual(Set(disjointSet.allSubsets()), expectedSubsets)

      let expectedCount = expectedSubsets.map { $0.count }.reduce(0) { $0 + $1 }
      XCTAssertEqual(disjointSet.count, expectedCount)

      let expectedIsEmpty = expectedCount == 0
      XCTAssertEqual(disjointSet.isEmpty, expectedIsEmpty)
   }
   
   static var allTests = [
      ("testEmpty", testEmpty),
      ("testInsertSingleMemberNoUnion", testInsertSingleMemberNoUnion),
      ("testInsertSingleMemberWithUnion", testInsertSingleMemberWithUnion),
      ("testInsertSingleMemberUnioningSelf", testInsertSingleMemberUnioningSelf),
      ("testInsertMultipleMembersNoUnion", testInsertMultipleMembersNoUnion),
      ("testInsertMultipleMembersWithUnion", testInsertMultipleMembersWithUnion),
      ("testInsertMultipleMembersWithDoubleUnion", testInsertMultipleMembersWithDoubleUnion),
      ("testValueTypeSemantics", testValueTypeSemantics),
   ]
}
