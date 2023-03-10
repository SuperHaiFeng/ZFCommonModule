//
//  TouchLommingAnimtionImpl.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/18.
//

import UIKit

/// touch渐隐动画
public class TouchLommingAnimtionImpl: TouchColorAnimation {
    public init() {
        
    }
    
    public func isTouchInside(isTouchInside: Bool, item: TouchColorItem, view: UIView) {
        let backColor = isTouchInside ? item.selectColor.cgColor : UIColor(white: 0, alpha: 0).cgColor
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setAnimationDuration(0.3)
        item.selectLayer.backgroundColor = backColor
        CATransaction.commit()
    }
    
    public func startAnimartion(item: TouchColorItem, _ touches: Set<UITouch>, with event: UIEvent?) {
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setAnimationDuration(0.3)
        item.selectLayer.backgroundColor = item.selectColor.cgColor
        CATransaction.commit()
    }
    
    public func disappearAnimation(item: TouchColorItem, _ touches: Set<UITouch>, with event: UIEvent?) {
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setCompletionBlock {
            item.selectLayer.removeFromSuperlayer()
        }
        item.selectLayer.backgroundColor = UIColor(white: 0, alpha: 0).cgColor
        CATransaction.commit()
    }
}

public class TouchColorDiffusionAnimationImpl: TouchColorAnimation {
    public init() {}
    
    public func isTouchInside(isTouchInside: Bool, item: TouchColorItem, view: UIView) {
        let backColor = isTouchInside ? item.selectColor.cgColor : UIColor(white: 0, alpha: 0).cgColor
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        let frame = isTouchInside ? view.bounds : CGRect(x: center.x, y: center.y, width: 0, height: 0)

        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setAnimationDuration(0.3)
        item.selectLayer.backgroundColor = backColor
        item.selectLayer.frame = frame
        CATransaction.commit()
    }
    
    public func startAnimartion(item: TouchColorItem, _ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: touch.view)
        item.selectLayer.frame = CGRect(x: point.x, y: point.y, width: 0, height: 0)
        
        CATransaction.begin()
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
            CATransaction.setAnimationDuration(0.3)
            item.selectLayer.backgroundColor = item.selectColor.cgColor
            item.selectLayer.frame = touch.view?.frame ?? .zero
        CATransaction.commit()
    }
        
    public func disappearAnimation(item: TouchColorItem, _ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: touch.view)
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setCompletionBlock {
            item.selectLayer.removeFromSuperlayer()
        }
        item.selectLayer.frame = CGRect(x: point.x, y: point.y, width: 0, height: 0)
        item.selectLayer.backgroundColor = UIColor(white: 0, alpha: 0).cgColor
        CATransaction.commit()
    }
}
