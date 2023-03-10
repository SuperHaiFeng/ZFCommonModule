//
//  ArrayLimitCount.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

/// 数组限制数量
/// 使用
/// @ArrayLimitCount<String>(count: 10)  限制数组数量在10以及以内
/// var limit =  [String] = ["a", "b"]

@propertyWrapper
public struct ArrayLimitCount<T> {
    private var arrays: [T]
    private var count: Int
    public init(count: Int) {
        self.count = count
        self.arrays = []
    }
    public var wrappedValue: [T] {
        get { return arrays }
        set {
            guard newValue.count > count else {
                arrays = newValue
                return
            }
            arrays = Array(newValue[0...count])
        }
    }
}
