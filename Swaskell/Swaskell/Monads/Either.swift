//
//  Either.swift
//  Swaskell
//
//  Copyright (c) 25/02/2021 Preston Spalding
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

enum Either<A,B> {
    case left(A)
    case right(B)
}

extension Either: Equatable where A: Equatable, B: Equatable {
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.right(a), .right(b)): return a == b
        case let (.left(a), .left(b)): return a == b
        case (_, _): return false
        }
    }
}

// MARK: Functor instance
func fmap<A,B,C>(_ f: (B) -> C, _ mb: Either<A,B>) -> Either<A,C> {
    switch mb {
    case .left(let a): return .left(a)
    case .right(let b): return .right(f(b))
    }
}

func <^><A,B,C>(_ f: (B) -> C, _ mb: Either<A,B>) -> Either<A,C> {
    return fmap(f, mb)
}

// MARK: Applicative instance
func apply<A,B,C>(_ mbc: Either<A,(B) -> C>, _ mb: Either<A,B>) -> Either<A,C> {
    switch mbc {
    case .left(let a): return .left(a)
    case .right(let f): return fmap(f,mb)
    }
}

func <*><A,B,C>(_ mbc: Either<A,((B) -> C)>, _ mb: Either<A,B>) -> Either<A,C> {
    return apply(mbc, mb)
}

// MARK: Monad instance
func bind<A,B,C>(_ mb: Either<A,B>, _ f: (B) -> Either<A,C>) -> Either<A,C> {
    switch mb {
    case .left(let a): return .left(a)
    case .right(let b): return f(b)
    }
}

func >>=<A,B,C>(_ mb: Either<A,B>, _ f: (B) -> Either<A,C>) -> Either<A,C> {
    return bind(mb, f)
}
