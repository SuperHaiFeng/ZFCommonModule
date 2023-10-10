//
//  String+Ex.swift
//  ZFCommonModule
//
//  Created by macode on 2023/10/10.
//

import Foundation

extension String {
    public func json() -> [String: Any]? {
        if let jsonData = self.data(using: .utf8) {
            if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return jsonObject
            }
        }
        return nil
    }
}
