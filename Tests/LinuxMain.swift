import XCTest

import DispatchBenchmarkTests

var tests = [XCTestCaseEntry]()
tests += DispatchBenchmarkTests.allTests()
XCTMain(tests)