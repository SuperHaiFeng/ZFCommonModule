//
//  BottomUpAnimation.swift
//  ZFCommonModule
//
//  Created by macode on 2023/3/8.
//

import UIKit

public class MovingAnimation: ViewTransitionsAnimationProtocol {
    public var delegate: Delegate<(start: Bool, disappear: Bool), Void>? = Delegate<(start: Bool, disappear: Bool), Void>()
    
    public var duration: CGFloat = 0.3
    
    public init(duration: CGFloat = 0.3) {
        self.duration = duration
    }
    
    public func startAnimation(target: UIView) { }
    
    fileprivate func startAnimation(target: UIView, translatedX: CGFloat, translatedY: CGFloat) {
        target.layoutIfNeeded()
        target.transform = CGAffineTransform.identity.translatedBy(x: translatedX, y: translatedY)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            target.transform = CGAffineTransform.identity
        } completion: { _ in
            self.delegate?.call((true, false))
        }
    }
    
    public func disappearAnimation(target: UIView) { }
    
    fileprivate func disappearAnimation(target: UIView, translatedX: CGFloat, translatedY: CGFloat) {
        target.layoutIfNeeded()
        UIView.animate(withDuration: duration) {
            target.transform = CGAffineTransform.identity.translatedBy(x: translatedX, y: translatedY)
        } completion: { (_) in
            self.delegate?.call((false, true))
        }
    }
}

/// 屏幕中间弹出动画
public class CenterDialogAnimation: ViewTransitionsAnimationProtocol {
    public var delegate: Delegate<(start: Bool, disappear: Bool), Void>? = Delegate<(start: Bool, disappear: Bool), Void>()
    
    public var duration: CGFloat = 0.3
    
    public init(duration: CGFloat = 0.3) {
        self.duration = duration
    }
    
    public func startAnimation(target: UIView) {
        target.layoutIfNeeded()
        target.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0).scaledBy(x: 0.8, y: 0.8)
        target.alpha = 0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseIn]) {
            target.transform = CGAffineTransform.identity
            target.alpha = 1
        } completion: { result in
            self.delegate?.call((true, false))
        }
    }
    
    public func disappearAnimation(target: UIView) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveEaseIn]) {
            target.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0).scaledBy(x: 0.8, y: 0.8)
            target.alpha = 0
        } completion: { result in
            self.delegate?.call((false, true))
        }
    }
}
 
/// 自下而上动画
public class BottomMoveUpAnimation: MovingAnimation {
    
    public override func startAnimation(target: UIView) {
        self.startAnimation(target: target, translatedX: 0, translatedY: target.bounds.height)
    }
    
    public override func disappearAnimation(target: UIView) {
        self.disappearAnimation(target: target, translatedX: 0, translatedY: target.bounds.height)
    }
}

/// 自下而上到中间的动画
public class BottomMoveCenterAnimation: MovingAnimation {
    public override func startAnimation(target: UIView) {
        let translatedY = target.bounds.height / 2 + ScreenHeight / 2
        self.startAnimation(target: target, translatedX: 0, translatedY: translatedY)
    }
    
    public override func disappearAnimation(target: UIView) {
        let translatedY = target.bounds.height / 2 + ScreenHeight / 2
        self.disappearAnimation(target: target, translatedX: 0, translatedY: translatedY)
    }
}

/// 自上而下动画
public class UpMoveBottomAnimation: MovingAnimation {
    public override func startAnimation(target: UIView) {
        self.startAnimation(target: target, translatedX: 0, translatedY: -target.bounds.height)
    }
    
    public override func disappearAnimation(target: UIView) {
        self.disappearAnimation(target: target, translatedX: 0, translatedY:  -target.bounds.height)
    }
}

/// 从左往右动画
public class LeftMoveRightAnimation: MovingAnimation {
    public override func startAnimation(target: UIView) {
        self.startAnimation(target: target, translatedX: -target.bounds.width, translatedY: 0)
    }
    
    public override func disappearAnimation(target: UIView) {
        self.disappearAnimation(target: target, translatedX: -target.bounds.width, translatedY: 0)
    }
}

/// 从右往左动画
public class RightMoveLeftAnimation: MovingAnimation {
    public override func startAnimation(target: UIView) {
        self.startAnimation(target: target, translatedX: target.bounds.width, translatedY: 0)
    }
    
    public override func disappearAnimation(target: UIView) {
        self.disappearAnimation(target: target, translatedX: target.bounds.width, translatedY: 0)
    }
}
