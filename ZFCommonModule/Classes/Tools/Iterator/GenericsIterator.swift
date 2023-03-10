//
//  GenericsIterator.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

/// 泛型迭代器

struct GenericsIterator<T>: IteratorProtocol {
    
    let chunkSize: Int
    let data: [T]

    init(chunkSize: Int, data: [T]) {
        self.chunkSize = chunkSize
        self.data = data
    }

    var offset = 0

    mutating func next() -> ArraySlice<T>? {
        let end = min(chunkSize, data.count - offset)
        let result = data[offset..<offset + end]
        offset += result.count
        return result.count > 0 ? result : nil
    }

}

struct GenericsSequence<T>: Sequence {
    let chunkSize: Int
    let data: [T]

    func makeIterator() -> GenericsIterator<T> {
        return GenericsIterator(chunkSize: chunkSize, data: data)
    }
}
