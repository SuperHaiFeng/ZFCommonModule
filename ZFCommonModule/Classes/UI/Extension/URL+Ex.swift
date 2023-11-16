//
//  URL+Ex.swift
//  ZFCommonModule
//
//  Created by macode on 2023/10/13.
//

import UIKit


extension URL {
    
    /// 参数
    public var parameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    /// 添加参数
    public func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0,    value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    
    public func queryParameters(key: String) -> String {
        return self.parameters?.first(where: { $0.key == key })?.value ?? ""
    }
    
    public func isContainsParameter(key: String) -> Bool {
        return parameters?.keys.contains(key) ?? false
    }
    
    public func containPath(path: String) -> Bool {
        return self.pathComponents.contains(path)
    }
}
