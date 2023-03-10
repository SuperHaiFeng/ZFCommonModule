//
//  LoomAnimation.swift
//  Alamofire
//
//  Created by macode on 2022/9/15.
//

import UIKit

 public struct ZoomLoomingItem {
    public let scaled: CGFloat
    public let damping: CGFloat
    public let startAlpha: CGFloat
    
    public init(scaled: CGFloat = 0.1, damping: CGFloat = 0.6, startAlpha: CGFloat = 0) {
        self.scaled = scaled
        self.damping = damping
        self.startAlpha = startAlpha
    }
}

/// 变大变小动画，从小变大 ｜ 从大变小
public class ZoomLoomingAnimation: ViewTransitionsAnimationProtocol {
    public var delegate: Delegate<(start: Bool, disappear: Bool), Void>? = Delegate<(start: Bool, disappear: Bool), Void>()
    public var duration: CGFloat
    
    private let item: ZoomLoomingItem
    
    public init(duration: CGFloat = 0.5, item: ZoomLoomingItem = ZoomLoomingItem()) {
        self.duration = duration
        self.item = item
    }
    
    public func startAnimation(target: UIView) {
        target.alpha = item.startAlpha
        target.transform = CGAffineTransform.identity.scaledBy(x: item.scaled, y: item.scaled)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: item.damping, initialSpringVelocity: 0, options: [.curveEaseIn]) {
            target.transform = CGAffineTransform.identity
            target.alpha = 1.0
        } completion: { result in
            self.delegate?.call((true, false))
        }
    }
    
    /// 消失动画
    public func disappearAnimation(target: UIView) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseIn]) {
            target.transform = CGAffineTransform.identity.scaledBy(x: self.item.scaled, y: self.item.scaled)
            target.alpha = 0
        } completion: { result in
            self.delegate?.call((false, true))
        }
    }
}
