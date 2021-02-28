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

struct Reader<E,A> {
    let runReader: (E) -> A
}

func fmap<A,B,E>(_ f: @escaping (A) -> B, _ ma: Reader<E,A>) -> Reader<E,B> {
    return Reader { e in
        f(ma.runReader(e))
    }
}

func apply<A,B,E>(_ mab: Reader<E,(A) -> B>, _ ma: Reader<E,A>) -> Reader<E,B> {
    return Reader { e in
        let f = mab.runReader(e)
        let a = ma.runReader(e)
        return f(a)
    }
}

func bind<A,B,E>(_ ma: Reader<E,A>, _ f: @escaping (A) -> Reader<E,B>) -> Reader<E,B> {
    return Reader { e in
        let a = ma.runReader(e)
        return f(a).runReader(e)
    }
}
