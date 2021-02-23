//
//  MaybeTests.swift
//  SwaskellTests
//
//  Copyright (c) 23/02/2021 Preston Spalding
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
@testable import Swaskell

class MaybeTests: XCTestCase {
    
    func test_maybe_function_returnsValueWithFunctionApplied() {
        XCTAssertEqual(maybe(default: 0, transform: { $0 * 2 }, value: .just(5)), 10)
        XCTAssertEqual(maybe(default: 0, transform: { $0 * 3 }, value: .just(5)), 15)
    }
    
    func test_maybe_function_returnsDefaultValueWhenNothingSupplied() {
        XCTAssertEqual(maybe(default: 0, transform: { $0 * 2 }, value: .nothing), 0)
        XCTAssertEqual(maybe(default: 10, transform: { $0 * 2 }, value: .nothing), 10)
    }
    
    func test_isJust_returnsTrueForJust() {
        XCTAssertTrue(isJust(.just(0)))
        XCTAssertTrue(isJust(.just(5)))
    }
    
    func test_isJust_returnsFalseForNothing() {
        let testValue: Maybe<Int> = .nothing
        XCTAssertFalse(isJust(testValue))
    }
    
    func test_isNothing_returnsFalseForJust() {
        XCTAssertFalse(isNothing(.just(0)))
        XCTAssertFalse(isNothing(.just(5)))
    }
    
    func test_isNothing_returnsTrueForNothing() {
        let testValue: Maybe<Int> = .nothing
        XCTAssertTrue(isNothing(testValue))
    }
    
    func test_fromJust_returnsValueForJust() {
        XCTAssertEqual(fromJust(.just(0)), 0)
        XCTAssertEqual(fromJust(.just(5)), 5)
    }
    
    func test_fromJust_throwsErrorsForNothing() {
        // TODO: Come back to this. It's possible, but more involved
    }
    
    func test_fromMaybe_returnsValueForJust() {
        XCTAssertEqual(fromMaybe(default: 0, value: .just(5)), 5)
        XCTAssertEqual(fromMaybe(default: 0, value: .just(10)), 10)
    }
    
    func test_fromMaybe_returnsDefaultValueForNothing() {
        XCTAssertEqual(fromMaybe(default: 0, value: .nothing), 0)
        XCTAssertEqual(fromMaybe(default: 5, value: .nothing), 5)
    }
    
    func test_listToMaybe_returnsFirstJustValueFromNonEmptyList() {
        // Can't use XCTAssertEqual until we can implement Equatable on Maybe
        // Current Swift version is 5.3
        XCTAssertEqual(listToMaybe([5]), .just(5))
        XCTAssertEqual(listToMaybe([10]), .just(10))
        XCTAssertEqual(listToMaybe([5,10]), .just(5))
        XCTAssertEqual(listToMaybe([10,5]), .just(10))
    }
    
    func test_listToMaybe_returns_nothingFromEmptyList() {
        XCTAssertEqual(listToMaybe([]), Maybe<Int>.nothing)
        XCTAssertEqual(listToMaybe([]), Maybe<String>.nothing)
    }
    
    func test_maybeToList_returnsListFromJust() {
        XCTAssertEqual(maybeToList(.just(5)), [5])
        XCTAssertEqual(maybeToList(.just(10)), [10])
    }
    
    func test_maybeToList_returns_emptyListFromNothing() {
        XCTAssertEqual(maybeToList(Maybe<Int>.nothing), [])
        XCTAssertEqual(maybeToList(Maybe<String>.nothing), [])
    }
    
    func test_mapMaybe_returnsCorrectElements() {
        let testFunc: (Int) -> Maybe<Int> = { $0 % 2 == 0 ? .just($0) : .nothing }
        XCTAssertEqual(mapMaybe(transform: testFunc, list: []), [])
        XCTAssertEqual(mapMaybe(transform: testFunc, list: [1,2,3,4,5]).count, 2)
        XCTAssertEqual(mapMaybe(transform: testFunc, list: [1,2,3,4,5]), [2, 4])
    }
}
