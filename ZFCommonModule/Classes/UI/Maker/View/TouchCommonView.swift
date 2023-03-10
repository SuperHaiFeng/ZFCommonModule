//
//  TouchZoomView.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/12.
//

import UIKit

/// 可以设置touch按下背景颜色 、touch zoom缩小动画
open class TouchCommonView: UIControl, TouchZoomAnimationProtocol, TouchColorProtocol, UIViewModifyTriggerProtocol {
    public var touchAnimation: TouchColorAnimation?
    
    /// 点击选择背景颜色
    public var touchColorItem: TouchColorItem?
        
    /// 扩大点击范围
    public var areaEdge: UIEdgeInsets = .zero
    
    /// 是否需要zoom动画
    public var touchZoomItem: TouchZoomAnimationItem?
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return pointInArea(inside: point, with: event)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        zoomTouchesBegan(touches, with: event)
        colorTouchesBegan(touches, with: event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        zoomTouchesEnded(touches, with: event)
        colorTouchesEnded(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        zoomTouchesCancelled(touches, with: event)
        colorTouchesCancelled(touches, with: event)
    }
    
    /// 使用 isTouchInside判断touch是否在有效触摸区域内，UIControl独有属性
    /// 此方法是持续跟踪触摸事件
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        colorIsTouchInside(isTouchInside: self.isTouchInside)
        return super.continueTracking(touch, with: event)
    }
}

extension TouchCommonView {
    /// 点击区域设置大小
    /// 扩大点击区域，对应数值为负数，反之为正数
    @discardableResult
    public func touchAreaEdge(_ edge: UIEdgeInsets) -> Self {
        self.areaEdge = edge
        return self
    }
}
