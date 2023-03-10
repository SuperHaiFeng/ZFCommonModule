//
//  KeyChain+Wrapper.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import Foundation
//import KeychainAccess

/// 修饰的属性会存储到 Keychain 中的 propertyWrapper
///     class Demo {
///         @KeyChainString("hello", defaultValue: "")
///         var hello: String!
///     }
//@propertyWrapper
//public struct KeyChainString {
//
//    private let keyChainAccess = KeychainAccess.Keychain()
//    let key: String
//    let defaultValue: String
//
//    public init(_ key: String, defaultValue: String) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//
//    public var wrappedValue: String! {
//        get {
//            if let result: String = try? keyChainAccess.get(self.key) ?? defaultValue {
//                return result
//            }
//            return defaultValue
//        }
//        set {
//            try? keyChainAccess.set(newValue, key: self.key)
//        }
//    }
//}
