//
//  UIViewModifyTriggerProtocol'.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

/// 修改UIView的点击触发区域
public protocol UIViewModifyTriggerProtocol where Self: UIView {
    /// 点击区域
    /// left top bottom right 必须都是负数
    var areaEdge: UIEdgeInsets { get set }
    
    func pointInArea(inside point: CGPoint, with event: UIEvent?) -> Bool
}

extension UIViewModifyTriggerProtocol {
    public func pointInArea(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        
        bounds = bounds.inset(by: areaEdge)
        return bounds.contains(point)
    }
}
