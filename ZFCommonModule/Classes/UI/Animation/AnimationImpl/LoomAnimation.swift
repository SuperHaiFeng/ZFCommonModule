//
//  LoomAnimation.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/15.
//

import UIKit

/// 隐现动画，实现该协议的视图可以自己设置颜色
public class LoomAnimation: ViewTransitionsAnimationProtocol {
    public var delegate: Delegate<(start: Bool, disappear: Bool), Void>? = Delegate<(start: Bool, disappear: Bool), Void>()
    public var duration: CGFloat
    private var color: UIColor = UIColor(white: 0, alpha: 0)
    
    public init(duration: CGFloat = 0.3, color: UIColor = UIColor(white: 0, alpha: 0.3)) {
        self.duration = duration
        self.color = color
    }
    
    public func startAnimation(target: UIView) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) {
            target.backgroundColor = self.color
        } completion: { result in
            self.delegate?.call((true, false))
        }
    }
    
    /// 消失动画
    public func disappearAnimation(target: UIView) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) {
            target.backgroundColor = self.color.withAlphaComponent(0)
        } completion: { result in
            self.delegate?.call((false, true))
        }
    }
}
