//
//  DropDownLommingAnimation.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/16.
//

import UIKit

/// 下拉动画
public class DropDownLommingAnimation: ViewTransitionsAnimationProtocol {
    public var delegate: Delegate<(start: Bool, disappear: Bool), Void>? = Delegate<(start: Bool, disappear: Bool), Void>()
    public var duration: CGFloat
    
    private let item: ZoomLoomingItem
    
    public init(duration: CGFloat = 0.5, item: ZoomLoomingItem = ZoomLoomingItem()) {
        self.duration = duration
        self.item = item
    }
    
    public func startAnimation(target: UIView) {
        target.layoutIfNeeded()
        target.alpha = item.startAlpha
        let translatedY = -target.frame.height / 2 * (1 - item.scaled)
        target.transform = CGAffineTransform.identity.translatedBy(x: 0, y: translatedY).scaledBy(x: item.scaled, y: item.scaled)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: item.damping, initialSpringVelocity: 0, options: [.curveEaseIn]) {
            target.transform = CGAffineTransform.identity
            target.alpha = 1.0
        } completion: { result in
            self.delegate?.call((true, false))
        }
    }
    
    /// 消失动画
    public func disappearAnimation(target: UIView) {
        let translatedY = -target.frame.height / 2 * (1 - item.scaled)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseIn]) {
            target.transform = CGAffineTransform.identity.translatedBy(x: 0, y: translatedY).scaledBy(x: self.item.scaled, y: self.item.scaled)
            target.alpha = self.item.startAlpha
        } completion: { result in
            self.delegate?.call((false, true))
        }
    }
}
