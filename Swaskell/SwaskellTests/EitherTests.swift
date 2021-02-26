//
//  EitherTests.swift
//  SwaskellTests
//
//  Copyright (c) 26/02/2021 Preston Spalding
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

class EitherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_either_withLeftValue_hasFirstFunctionApplied() {
        XCTAssertEqual(either(addTwo, multipleByThree, value: .left(5)), 7)
        XCTAssertEqual(either(addTwo, multipleByThree, value: .left(10)), 12)
    }
    
    func test_either_withRightValue_hasSecondFunctionApplied() {
        XCTAssertEqual(either(addTwo, multipleByThree, value: .right(5)), 15)
        XCTAssertEqual(either(addTwo, multipleByThree, value: .right(10)), 30)
    }
    
    func test_lefts_returnsListOfLeftValuesOnly() {
        XCTAssertEqual(lefts([Either<String, Int>.left("E1"), .left("E2"), .left("E3")]), ["E1", "E2", "E3"])
        XCTAssertEqual(lefts([Either.left("E1"), .right(0), .left("E2")]), ["E1", "E2"])
        XCTAssertEqual(lefts([Either<String, Int>.right(0), .right(3)]), [])
    }
    
    func test_rights_returnsListOfRightValuesOnly() {
        XCTAssertEqual(rights([Either<String, Int>.left("E1"), .left("E2")]), [])
        XCTAssertEqual(rights([Either.left("E1"), .right(0), .right(2), .right(4), .left("E2")]), [0, 2, 4])
        XCTAssertEqual(rights([Either<String, Int>.right(0), .right(3)]), [0, 3])
    }
    
    func test_isLeft_returnsTrueWhenLeft() {
        let leftValues: [Either<String,Int>] = [.left("E1"), .left("E2"), .left("E3")]
        leftValues.forEach { XCTAssertTrue(isLeft($0)) }
        let rightValues: [Either<String,Int>] = [.right(1), .right(2), .right(3)]
        rightValues.forEach { XCTAssertFalse(isLeft($0)) }
    }
    
    func test_isRight_returnsTrueWhenRight() {
        let leftValues: [Either<String,Int>] = [.left("E1"), .left("E2"), .left("E3")]
        leftValues.forEach { XCTAssertFalse(isRight($0)) }
        let rightValues: [Either<String,Int>] = [.right(1), .right(2), .right(3)]
        rightValues.forEach { XCTAssertTrue(isRight($0)) }
    }
}

extension EitherTests {
    
    func addTwo(_ value: Int) -> Int {
        return value + 2
    }
    
    func multipleByThree( value: Int) -> Int {
        return value * 3
    }
}
