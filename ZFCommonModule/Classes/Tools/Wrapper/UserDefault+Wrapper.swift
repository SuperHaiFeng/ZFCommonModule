//
//  UserDefault+Wrapper.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

/// 修饰的属性会存储到 UserDefaults 中的 propertyWrapper
///
///     class Demo {
///
///         /// showGuide 会保存到 UserDefaults 中, key 为 show_guide
///         @UserDefault("show_guide", defaultValue: false)
///         var showGuide: Bool
///     }

@propertyWrapper
public struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    let defaults: UserDefaults?
    
    public init(_ key: String, defaultValue: T, defaults: UserDefaults? = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
    }
    
    public var wrappedValue: T {
        get {
            return defaults?.object(forKey: key) as? T ?? defaultValue
        }
        set {
            defaults?.set(newValue, forKey: key)
        }
    }
}
