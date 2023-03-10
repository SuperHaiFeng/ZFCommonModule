//
//  TouchAnimationProtocal.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/12.
//

import UIKit

public struct TouchZoomAnimationItem {
    public var isZoom: Bool = true
    /// 阻尼系数 越小，越明显
    public var damping: CGFloat = 0.8
    /// 缩小比例
    public var scale: CGFloat = 0.96
    /// 缩小时间
    public var beginDuration: CGFloat = 0.3
    /// 恢复时间
    public var endDuration: CGFloat = 0.3
    
    /// <#Description#>
    /// - Parameters:
    ///   - damping: 阻尼系数
    ///   - scale: 缩小比例
    ///   - begin: 缩小时间
    ///   - end: 恢复时间
    public init(_ damping: CGFloat = 0.8, scale: CGFloat = 0.96, begin: CGFloat = 0.3, end: CGFloat = 0.3) {
        self.damping = damping
        self.scale = scale
        self.beginDuration = begin
        self.endDuration = end
    }
}

/// 点击缩放动画
public protocol TouchZoomAnimationProtocol where Self: UIView {
    var touchZoomItem: TouchZoomAnimationItem? { get set }
    /// 放大缩小动画
    func touchZoomItem(_ zoom: TouchZoomAnimationItem) -> Self
}

extension TouchZoomAnimationProtocol {
    public var isShowZoom: Bool {
        get {
            touchZoomItem?.isZoom ?? false
        }
    }
    
    public func zoomTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchZoomAnimation(begin: true)
    }
    
    public func zoomTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchZoomAnimation(begin: false)
    }
    
    public func zoomTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchZoomAnimation(begin: false)
    }
    
    /// 执行缩放动画
    public func touchZoomAnimation(begin: Bool) {
        guard let item = touchZoomItem, isShowZoom else { return }
        var transform = CGAffineTransform.identity
        var duration = item.endDuration
        if begin {
            transform = transform.scaledBy(x: item.scale, y: item.scale)
            duration = item.beginDuration
        }
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: item.damping, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
          self.transform = transform
        }, completion: nil)
    }
}

// MARK: 设置属性
extension TouchZoomAnimationProtocol {
    /// 放大缩小动画
    public func touchZoomItem(_ zoom: TouchZoomAnimationItem) -> Self {
        self.touchZoomItem = zoom
        return self
    }
}
