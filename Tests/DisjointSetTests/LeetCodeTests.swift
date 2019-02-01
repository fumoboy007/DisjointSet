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
import DisjointSet

final class LeetCodeTests: XCTestCase {
   // https://leetcode.com/problems/longest-consecutive-sequence/
   func testLongestConsecutiveSequence() {
      let numbers = [100, 4, 200, 1, 3, 2]

      var disjointSet = DisjointSet<Int>()
      for number in numbers {
         disjointSet.insert(number,
                            unioningWith: [number - 1, number + 1])
      }

      let maxConsecutiveSequenceCount =
         disjointSet.allSubsets().lazy
            .map { $0.count }
            .max() ?? 0

      XCTAssertEqual(maxConsecutiveSequenceCount, 4)
   }

   // https://leetcode.com/problems/redundant-connection/
   func testFindRedundantConnection() {
      struct UndirectedEdge: Equatable {
         let u: Int
         let v: Int

         init(_ u: Int, _ v: Int) {
            self.u = u
            self.v = v
         }
      }

      let edges: [UndirectedEdge] = [
         .init(1, 2),
         .init(2, 3),
         .init(3, 4),
         .init(1, 4),
         .init(1, 5)
      ]

      var disjointSet = DisjointSet<Int>()
      var edgeToBeRemoved: UndirectedEdge?
      for edge in edges {
         if disjointSet.contains(edge.u) && disjointSet.contains(edge.v) {
            edgeToBeRemoved = edge
            break
         }

         disjointSet.insert(edge.u, unioningWith: [edge.v])
         disjointSet.insert(edge.v, unioningWith: [edge.u])
      }

      XCTAssertNotNil(edgeToBeRemoved)
      XCTAssertEqual(edgeToBeRemoved!, .init(1, 4))
   }

   static var allTests = [
      ("testLongestConsecutiveSequence", testLongestConsecutiveSequence),
      ("testFindRedundantConnection", testFindRedundantConnection),
   ]
}
