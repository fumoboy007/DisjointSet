import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
   return [
      testCase(DisjointSetLogicTests.allTests),
      testCase(LeetCodeTests.allTests),
   ]
}
#endif
