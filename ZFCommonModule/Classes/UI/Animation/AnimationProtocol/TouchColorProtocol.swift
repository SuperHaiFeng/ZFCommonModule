//
//  TouchColorProtocol.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/12.
//

import UIKit

public struct TouchColorItem {
    public let isSelect: Bool = true
    public let selectColor: UIColor
    public let selectLayer: CALayer
    
    public init(selectColor: UIColor = UIColor(white: 0, alpha: 0.2),
                selectLayer: CALayer = CALayer(),
                corner: CGFloat = 0, zPosion: CGFloat = 0) {
        self.selectColor = selectColor
        self.selectLayer = selectLayer
        self.selectLayer.cornerRadius = corner
        self.selectLayer.zPosition = zPosion
    }
}

/// 点击view显示背景颜色
public protocol TouchColorProtocol where Self: UIView {
    var touchColorItem: TouchColorItem? { get set }
    
    var touchAnimation: TouchColorAnimation? { get set }
    
    /// 是否打开选择背景视图
    func touchColor(_ item: TouchColorItem, _ animation: TouchColorAnimation) -> Self
}

public protocol TouchColorAnimation {
    /// 手指是否在事件内
    func isTouchInside(isTouchInside: Bool, item: TouchColorItem, view: UIView)
    
    /// 开始动画
    func startAnimartion(item: TouchColorItem, _ touches: Set<UITouch>, with event: UIEvent?)
    
    /// 消失动画
    func disappearAnimation(item: TouchColorItem, _ touches: Set<UITouch>, with event: UIEvent?)
}

extension TouchColorProtocol {
    public var isShowTouchColor: Bool {
        get {
            return self.touchColorItem?.isSelect ?? false
        }
    }
    
    public func colorTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchSelectLayer(begin: true, touches, with: event)
    }
    
    public func colorTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchSelectLayer(begin: false, touches, with: event)
    }
    
    public func colorTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchSelectLayer(begin: false, touches, with: event)
    }
    
    /// 判断touch是否在有效区域内 使用 isTouchInside
    public func colorIsTouchInside(isTouchInside: Bool) {
        guard let item = self.touchColorItem else { return }
        touchAnimation?.isTouchInside(isTouchInside: isTouchInside, item: item, view: self)
    }
    
    /// 执行点击背景颜色动画
    public func touchSelectLayer(begin: Bool, _ touches: Set<UITouch>, with event: UIEvent?) {
        guard isShowTouchColor else { return }
        if begin {
            touchColorItem?.selectLayer.frame = self.bounds
            self.layer.addSublayer((touchColorItem?.selectLayer)!)
            touchAnimation?.startAnimartion(item: touchColorItem!, touches, with: event)
        } else {
            touchAnimation?.disappearAnimation(item: touchColorItem!, touches, with: event)
        }
    }
}

// MARK: 设置属性
extension TouchColorProtocol {
    /// 是否打开选择背景视图
    @discardableResult
    public func touchColor(_ item: TouchColorItem, _ animation: TouchColorAnimation) -> Self {
        self.touchColorItem = item
        self.touchAnimation = animation
        return self
    }
}
