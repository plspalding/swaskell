//
//  ReaderTests.swift
//  SwaskellTests
//
//  Copyright (c) 01/03/2021 Preston Spalding
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

class ReaderTests: XCTestCase {

    func test_reader_returnsReaderMonad() {
        XCTAssertEqual(reader(addFive).runReader(5), 10)
        XCTAssertEqual(reader(addFive).runReader(10), 15)
        XCTAssertEqual(reader(addExclamationMark).runReader("Tom"), "Tom!")
        XCTAssertEqual(reader(addExclamationMark).runReader("Jack"), "Jack!")
    }

    func test_mapReader_transformsValueWithProvidedFunction() {
        let sut: Reader<Int, Int> = reader(id)
        XCTAssertEqual(mapReader(addFive, sut).runReader(5), 10)
        XCTAssertEqual(mapReader(addFive, sut).runReader(10), 15)
    }
    
    func test_withReader_transformsEnvironmentBeforeApplying() {
        let r: Reader<String, String> = reader { x in x + x }
        let sut = withReader(addExclamationMark, r)
        XCTAssertEqual(sut.runReader("Hello"), "Hello!Hello!")
        XCTAssertEqual(sut.runReader("Hola"), "Hola!Hola!")
    }
    
    func test_ask_givesBackR() {
        XCTAssertEqual(ask().runReader("Hello"), "Hello")
        XCTAssertEqual(ask().runReader(5), 5)
    }
    
    enum Env {
        case debug
        case staging
        case production
    }
}

func id<A>(_ a: A) -> A {
    return a
}

func addFive(_ x: Int) -> Int {
    return x + 5
}

func addExclamationMark(_ s:String) -> String {
    return s + "!"
}
