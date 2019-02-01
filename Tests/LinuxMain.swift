import XCTest

import DisjointSetTests

var tests = [XCTestCaseEntry]()
tests += DisjointSetTests.allTests()
XCTMain(tests)