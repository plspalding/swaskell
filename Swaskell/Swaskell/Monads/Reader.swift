//
//  Reader.swift
//  Swaskell
//
//  Copyright (c) 28/02/2021 Preston Spalding
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

import Foundation

struct Reader<R,A> {
    let runReader: (R) -> A
}

func fmap<R,A,B>(_ f: @escaping (A) -> B, _ ma: Reader<R,A>) -> Reader<R,B> {
    return Reader { e in
        f(ma.runReader(e))
    }
}

func <^><R,A,B>(_ f: @escaping (A) -> B, _ ma: Reader<R,A>) -> Reader<R,B> {
    return fmap(f, ma)
}

func apply<R,A,B>(_ mab: Reader<R,(A) -> B>, _ ma: Reader<R,A>) -> Reader<R,B> {
    return Reader { e in
        let f = mab.runReader(e)
        let a = ma.runReader(e)
        return f(a)
    }
}

func <*><R,A,B>(_ mab: Reader<R,(A) -> B>, _ ma: Reader<R,A>) -> Reader<R,B> {
    return apply(mab, ma)
}

func bind<R,A,B>(_ ma: Reader<R,A>, _ f: @escaping (A) -> Reader<R,B>) -> Reader<R,B> {
    return Reader { e in
        let a = ma.runReader(e)
        return f(a).runReader(e)
    }
}

func >>=<R,A,B>(_ ma: Reader<R,A>, _ f: @escaping (A) -> Reader<R,B>) -> Reader<R,B> {
    return bind(ma, f)
}

func >>-<R,A,B>(_ ma: Reader<R,A>, _ f: @escaping (A) -> Reader<R,B>) -> Reader<R,B> {
    return bind(ma, f)
}

// Functions
func reader<A,R>(_ f: @escaping (R) -> A) -> Reader<R,A> {
    return Reader(runReader: f)
}

func mapReader<R,A,B>(_ f: @escaping (A) -> B, _ ma: Reader<R,A>) -> Reader<R,B> {
    return fmap(f, ma)
}

func withReader<R,A>(_ f: @escaping (R) -> R, _ ma: Reader<R,A>) -> Reader<R,A> {
    return Reader { ma.runReader(f($0)) }
}

func ask<R>() -> Reader<R,R> {
    return Reader { $0 }
}

func asks<R,A>(_ f: @escaping (R) -> A) -> Reader<R,A> {
    return Reader {
        f($0)
    }
}

enum Color {
    case red
    case blue
    case green
}

func ==(lhs: Color, rhs: Color) -> Bool {
    switch (lhs, rhs) {
    case (.red, .red), (.blue, .blue), (.green, .green): return true
    default:
        return false
    }
}
