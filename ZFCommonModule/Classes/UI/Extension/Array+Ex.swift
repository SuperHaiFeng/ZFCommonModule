//
//  Array+Ex.swift
//  ZFCommonModule
//
//  Created by macode on 2023/10/10.
//

extension Array {
    /// 避免数组越界的问题.   let value = elements[safe: 5]
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Array where Element:Hashable {
    public var unique:[Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
}
