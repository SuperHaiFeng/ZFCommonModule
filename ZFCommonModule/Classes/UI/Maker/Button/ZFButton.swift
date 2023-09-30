//
//  ZFButton.swift
//  Alamofire
//
//  Created by macode on 2022/9/2.
//

import UIKit

public enum DirectionPlacement {
    case leading
    case top
    case bottom
    case treading
}

open class ZFButton: UIButton, UIViewModifyTriggerProtocol, TouchZoomAnimationProtocol, TouchColorProtocol {
    public var touchAnimation: TouchColorAnimation?
    
    public var touchColorItem: TouchColorItem?
    public var touchZoomItem: TouchZoomAnimationItem?
    public var areaEdge: UIEdgeInsets = .zero
    
    public override var isHighlighted: Bool {
        didSet {
            if #available(iOS 15.0, *) {
                if isHighlighted, let highImg = self.backgroundImage(for: .highlighted) {
                    self.configuration?.background.image = highImg
                } else if let nomalImg = self.backgroundImage(for: .normal) {
                    self.configuration?.background.image = nomalImg
                }
            }
        }
    }
    
    /// 是否可以显示点击背景颜色
    private var isTouchColor: Bool {
        get {
            if #available(iOS 15.0, *) {
                return true
            } else if self.backgroundImage(for: .normal) == nil {
                return true
            }
            return false
        }
    }
    
    public convenience init(buttonType: UIButton.ButtonType) {
        self.init(type: buttonType)
        if #available(iOS 15.0, *) {
//            self.configuration = UIButton.Configuration.filled()
        }
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return pointInArea(inside: point, with: event)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        zoomTouchesBegan(touches, with: event)
        if isTouchColor {
            colorTouchesBegan(touches, with: event)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        zoomTouchesEnded(touches, with: event)
        if isTouchColor {
            colorTouchesEnded(touches, with: event)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        zoomTouchesCancelled(touches, with: event)
        if isTouchColor {
            colorTouchesCancelled(touches, with: event)
        }
    }
    
    /// 使用 isTouchInside判断touch是否在有效触摸区域内
    /// 此方法是持续跟踪触摸事件
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isTouchColor {
            colorIsTouchInside(isTouchInside: self.isTouchInside)
        }
        return super.continueTracking(touch, with: event)
    }
    
}

extension ZFButton {
    /// 字体颜色
    @discardableResult
    public func titleColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }

    /// 文本信息
    @discardableResult
    public func title(_ title: String, _ state: UIControl.State = .normal) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    /// 设置富文本
    @discardableResult
    public func attrTitle(_ attr: NSAttributedString, _ state: UIControl.State = .normal) -> Self {
        self.setAttributedTitle(attr, for: state)
        return self
    }
    
    /// 字体
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }

    /// 点击区域设置大小
    /// 扩大点击区域，对应数值为负数，反之为正数
    @discardableResult
    public func touchAreaEdge(_ edge: UIEdgeInsets) -> Self {
        self.areaEdge = edge
        return self
    }
    
    /// 背景图片
    @discardableResult
    public func bgImage(_ bgImg: UIImage?, _ state: UIControl.State = .normal) -> Self {
        if #available(iOS 15.0, *) {
            if state == .normal {
                var background = UIBackgroundConfiguration.listPlainCell()
                background.image = bgImg
                self.configuration?.background = background
            }
        }
        self.setBackgroundImage(bgImg, for: state)
        return self
    }
    
    /// 图片
    @discardableResult
    public func image(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    public func titleShadowColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        self.setTitleShadowColor(color, for: state)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func role(_ role: UIButton.Role) -> Self {
        self.role = role
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func menu(_ menu: UIMenu) -> Self {
        self.menu = menu
        return self
    }
    
    @available(iOS 13.4, *)
    @discardableResult
    public func isPointerInteractionEnabled(_ enabled: Bool) -> Self {
        self.isPointerInteractionEnabled = enabled
        return self
    }
    
    @available(iOS 15, *)
    @discardableResult
    public func changesSelectionAsPrimaryAction(_ enabled: Bool) -> Self {
        self.changesSelectionAsPrimaryAction = enabled
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, _ state: UIControl.State = .normal) -> Self {
        self.setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }
    
    /// 需要先设置image与title再调用
    /// 15.0以后使用Configuration配置，设置背景图片会失效
    public func imageEdge(_ plagement: DirectionPlacement,_ imagePadding: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            switch plagement {
                case .leading:
                    self.configuration?.imagePlacement = .leading
                case .top:
                    self.configuration?.imagePlacement = .top
                case .bottom:
                    self.configuration?.imagePlacement = .bottom
                case .treading:
                    self.configuration?.imagePlacement = .trailing
            }
            self.configuration?.imagePadding = imagePadding
        } else {
            let imageWith = self.imageView?.image?.size.width ?? 0
            let imageHeight = self.imageView?.image?.size.height ?? 0
            
            let labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0
            let labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0
            
            var imageEdgeInsets = UIEdgeInsets.zero
            var labelEdgeInsets = UIEdgeInsets.zero
            var contentEdgeInsets = UIEdgeInsets.zero
            
//            let bWidth = self.bounds.width
            
            let min_height = min(imageHeight, labelHeight)
            
            switch plagement {
                case .leading:
                    self.contentVerticalAlignment = .center
                    imageEdgeInsets = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
                    labelEdgeInsets = UIEdgeInsets(top: 0,
                                                   left: imagePadding,
                                                   bottom: 0,
                                                   right: -imagePadding)
                    contentEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: imagePadding)
                case .top:
                    //img在上或者在下 一版按钮是水平垂直居中的
                    self.contentHorizontalAlignment = .center
                    self.contentVerticalAlignment = .center
                    
                    let w_di = labelWidth / 2.0
                    //如果内容宽度大于button宽度 改变计算方式
//                    if (labelWidth+imageWith + imagePadding) > bWidth{
//                        w_di = (bWidth - imageWith)/2
//                    }
                    //考虑图片+显示文字宽度大于按钮总宽度的情况
//                    let labelWidth_f = self.titleLabel?.frame.width ?? 0
//                    if (imageWith + labelWidth_f + imagePadding) > bWidth{
//                        w_di = (bWidth - imageWith)/2
//                    }
                    imageEdgeInsets = UIEdgeInsets(top: -(labelHeight + imagePadding),
                                                   left: w_di,
                                                   bottom: 0,
                                                   right: -w_di)
                    labelEdgeInsets = UIEdgeInsets(top: 0,
                                                   left: -imageWith,
                                                   bottom: -(imagePadding + imageHeight),
                                                   right: 0)
                    let h_di = (min_height + imagePadding) / 2.0
                    contentEdgeInsets = UIEdgeInsets(top:h_di,left: 0,bottom:h_di,right: 0)
                case .bottom:
                    //img在上或者在下 一版按钮是水平垂直居中的
                    self.contentHorizontalAlignment = .center
                    self.contentVerticalAlignment = .center
                    let w_di = labelWidth / 2
                    //如果内容宽度大于button宽度 改变计算方式
//                    if (labelWidth+imageWith + imagePadding) > bWidth{
//                        w_di = (bWidth - imageWith) / 2
//                    }
                  //考虑图片+显示文字宽度大于按钮总宽度的情况
//                    let labelWidth_f = self.titleLabel?.frame.width ?? 0
//                    if (imageWith+labelWidth_f + imagePadding) > bWidth{
//                        w_di = (bWidth - imageWith) / 2
//                    }
                    imageEdgeInsets = UIEdgeInsets(top: 0,
                                                   left: w_di,
                                                   bottom: -(labelHeight + imagePadding),
                                                   right: -w_di)
                    labelEdgeInsets = UIEdgeInsets(top: -(imagePadding + imageHeight),
                                                   left: -imageWith,
                                                   bottom: 0,
                                                   right: 0)
                    let h_di = (min_height + imagePadding) / 2.0
                    contentEdgeInsets = UIEdgeInsets(top:h_di, left: 0,bottom:h_di,right: 0)
                case .treading:
                    self.contentVerticalAlignment = .center
                    let w_di = labelWidth + imagePadding / 2
//                    if (labelWidth + imageWith + imagePadding) > bWidth{
//                        let labelWidth_f = self.titleLabel?.frame.width ?? 0
//                        w_di = labelWidth_f + imagePadding / 2
//                    }
                    imageEdgeInsets = UIEdgeInsets(top: 0,
                                                   left: w_di,
                                                   bottom: 0,
                                                   right: -w_di)
                    labelEdgeInsets = UIEdgeInsets(top: 0,
                                                   left: -(imageWith + imagePadding / 2),
                                                   bottom: 0,
                                                   right: imageWith + imagePadding / 2)
                    contentEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding / 2, bottom: 0, right: imagePadding / 2.0)
            }
            self.contentEdgeInsets = contentEdgeInsets
            self.titleEdgeInsets = labelEdgeInsets
            self.imageEdgeInsets = imageEdgeInsets
        }
        return self
    }
}
