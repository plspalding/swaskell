//
//  Maybe.swift
//  Swaskell
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

import Foundation

// MARK: Maybe data type
enum Maybe<A> {
    case just(A)
    case nothing
}

extension Maybe: Equatable where A: Equatable {
    static func ==(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
        switch (lhs, rhs) {
        case (.just(let a), .just(let b)): return a == b
        case (.nothing, .nothing): return true
        case (_,_): return false
        }
    }
}

// MARK: Functor instance
func fmap<A,B>(_ f: (A) -> (B), _ ma: Maybe<A>) -> Maybe<B> {
    switch ma {
    case .just(let a): return .just(f(a))
    case .nothing: return .nothing
    }
}

func <^><A,B>(_ f: (A) -> B, _ ma: Maybe<A>) -> Maybe<B> {
    return fmap(f, ma)
}

// MARK: Applicative instance
func apply<A,B>(_ mf: Maybe<(A) -> B>, _ ma: Maybe<A>) -> Maybe<B> {
    switch mf {
    case .just(let f): return fmap(f, ma)
    case .nothing: return .nothing
    }
}

func <*><A,B>(_ mf: Maybe<(A) -> B>, _ ma: Maybe<A>) -> Maybe<B> {
    return apply(mf, ma)
}

// MARK: Monad instance
func bind<A,B>(_ ma: Maybe<A>, _ f: (A) -> Maybe<B>) -> Maybe<B> {
    switch ma {
    case .just(let a): return f(a)
    case .nothing: return .nothing
    }
}

func >>=<A,B>(_ ma: Maybe<A>, _ f: (A) -> Maybe<B>) -> Maybe<B> {
    return bind(ma, f)
}

// Functions
func maybe<A,B>(default: B, transform: (A) -> B, value: Maybe<A>) -> B {
    switch value {
    case .just(let a): return transform(a)
    case .nothing: return `default`
    }
}

func isJust<A>(_ ma: Maybe<A>) -> Bool {
    switch ma {
    case .just: return true
    case .nothing: return false
    }
}

func isNothing<A>(_ ma: Maybe<A>) -> Bool {
    !isJust(ma)
}

func fromJust<A>(_ ma: Maybe<A>) -> A {
    switch ma {
    case .just(let a): return a
    case .nothing: fatalError("*** Exception: Maybe.fromJust: Nothing")
    }
}

func fromMaybe<A>(default: A, value: Maybe<A>) -> A {
    switch value {
    case .just(let a): return a
    case .nothing: return `default`
    }
}

func listToMaybe<A>(_ list: [A]) -> Maybe<A> {
    list.first.map { .just($0) } ?? .nothing
}

func maybeToList<A>(_ value: Maybe<A>) -> [A] {
    fromMaybe(default: [], value: { x in [x] } <^> value)
}

func catMaybe<A>(list: [Maybe<A>]) -> [A] {
    var array: [A] = []
    for value in list {
        switch value {
        case .just(let a): array.append(a)
        case .nothing: continue
        }
    }
    return array
}

func mapMaybe<A,B>(transform: (A) -> Maybe<B>, list: [A]) -> [B] {
    var array: [Maybe<B>] = []
    for value in list {
        array.append(transform(value))
    }
    return catMaybe(list: array)
}
