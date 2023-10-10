//
//  MRTabBarItemContentView.swift
//  PopVoiceLive
//
//  Created by 董帅军 on 2020/3/30.
//  Copyright © 2020 Talla. All rights reserved.
//

import UIKit

public enum MRTabBarItemContentMode: Int {
    case alwaysOriginal // Always set the original image size
    case alwaysTemplate // Always set the image as a template image size
}

open class MRTabBarItemContentView: UIView {
    // MARK: - PROPERTY SETTING

    /// 设置contentView的偏移
    open var insets = UIEdgeInsets.zero
    /// 是否被选中
    open var selected = false
    /// 是否处于高亮状态
    open var highlighted = false
    /// 是否支持高亮
    open var highlightEnabled = true
    /// 文字颜色
    open var textColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected { titleLabel.textColor = textColor }
        }
    }

    /// 高亮时文字颜色
    open var highlightTextColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected { titleLabel.textColor = highlightIconColor }
        }
    }

    /// icon颜色
    open var iconColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected { imageView.tintColor = iconColor }
        }
    }

    /// 高亮时icon颜色
    open var highlightIconColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected { imageView.tintColor = highlightIconColor }
        }
    }

    /// 背景颜色
    open var backdropColor = UIColor.clear {
        didSet {
            if !selected { backgroundColor = backdropColor }
        }
    }

    /// 高亮时背景颜色
    open var highlightBackdropColor = UIColor.clear {
        didSet {
            if selected { backgroundColor = highlightBackdropColor }
        }
    }

    open var title: String? {
        didSet {
            self.titleLabel.text = title
            self.updateLayout()
        }
    }

    /// Icon imageView renderingMode, default is .alwaysTemplate like UITabBarItem
    open var renderingMode: UIImage.RenderingMode = .alwaysTemplate {
        didSet {
            self.updateDisplay()
        }
    }

    /// Item content mode, default is .alwaysTemplate like UITabBarItem
    open var itemContentMode: MRTabBarItemContentMode = .alwaysTemplate {
        didSet {
            self.updateDisplay()
        }
    }

    /// Icon imageView's image
    open var image: UIImage? {
        didSet {
            if !selected { self.updateDisplay() }
        }
    }

    open var selectedImage: UIImage? {
        didSet {
            if selected { self.updateDisplay() }
        }
    }

    open var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        return imageView
    }()

    open var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .clear
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    /// Badge value
    open var badgeValue: String? {
        didSet {
            if let validValue = badgeValue, validValue.count > 0 {
                self.badgeView.badgeValue = badgeValue
                self.addSubview(badgeView)
                self.updateLayout()
            } else {
                // Remove when nil.
                self.badgeView.removeFromSuperview()
            }
            badgeChanged(animated: true, completion: nil)
        }
    }

    open var badgeColor: UIColor? {
        didSet {
            if let _ = badgeColor {
                self.badgeView.badgeColor = badgeColor
            } else {
                self.badgeView.badgeColor = MRTabBarItemBadgeView.defaultBadgeColor
            }
        }
    }

    open var badgeView: MRTabBarItemBadgeView = MRTabBarItemBadgeView() {
        willSet {
            if let _ = badgeView.superview {
                badgeView.removeFromSuperview()
            }
        }
        didSet {
            if let _ = badgeView.superview {
                self.updateLayout()
            }
        }
    }

    open var badgeOffset: UIOffset = UIOffset(horizontal: 6.0, vertical: -22.0) {
        didSet {
            if badgeOffset != oldValue {
                updateLayout()
            }
        }
    }

    // MARK: -

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false

        addSubview(imageView)
        addSubview(titleLabel)

        titleLabel.textColor = textColor
        imageView.tintColor = iconColor
        backgroundColor = backdropColor
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func updateDisplay() {
        imageView.image = (selected ? (selectedImage ?? image) : image)?.withRenderingMode(renderingMode)
        imageView.tintColor = selected ? highlightIconColor : iconColor
        titleLabel.textColor = selected ? highlightTextColor : textColor
        backgroundColor = selected ? highlightBackdropColor : backdropColor
    }

    open func updateLayout() {
        let w = bounds.size.width
        let h = bounds.size.height

        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)

        if itemContentMode == .alwaysTemplate {
            var s: CGFloat = 0.0 // image size
            var f: CGFloat = 0.0 // font
            var isLandscape = false
            if let keyWindow = UIApplication.shared.keyWindow {
                isLandscape = keyWindow.bounds.width > keyWindow.bounds.height
            }
            let isWide = isLandscape || traitCollection.horizontalSizeClass == .regular // is landscape or regular
            if #available(iOS 11.0, *), isWide {
                s = UIScreen.main.scale == 3.0 ? 23.0 : 20.0
                f = UIScreen.main.scale == 3.0 ? 13.0 : 12.0
            } else {
                s = 23.0
                f = 10.0
            }

            if !imageView.isHidden, !titleLabel.isHidden {
                titleLabel.font = UIFont.systemFont(ofSize: f, weight: .medium)
                titleLabel.sizeToFit()
                if #available(iOS 11.0, *), isWide {
                    titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0 + (UIScreen.main.scale == 3.0 ? 14.25 : 12.25),
                                              y: (h - titleLabel.bounds.size.height) / 2.0,
                                              width: titleLabel.bounds.size.width,
                                              height: titleLabel.bounds.size.height)
                    imageView.frame = CGRect(x: titleLabel.frame.origin.x - s - (UIScreen.main.scale == 3.0 ? 6.0 : 5.0),
                                             y: (h - s) / 2.0,
                                             width: s,
                                             height: s)
                } else {
                    titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                              y: h - titleLabel.bounds.size.height - 1.0,
                                              width: titleLabel.bounds.size.width,
                                              height: titleLabel.bounds.size.height)
                    imageView.frame = CGRect(x: (w - s) / 2.0,
                                             y: (h - s) / 2.0 - 6.0,
                                             width: s,
                                             height: s)
                }
            } else if !imageView.isHidden {
                imageView.frame = CGRect(x: (w - s) / 2.0,
                                         y: (h - s) / 2.0,
                                         width: s,
                                         height: s)
            } else if !titleLabel.isHidden {
                titleLabel.font = UIFont.systemFont(ofSize: f, weight: .medium)
                titleLabel.sizeToFit()
                titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                          y: (h - titleLabel.bounds.size.height) / 2.0,
                                          width: titleLabel.bounds.size.width,
                                          height: titleLabel.bounds.size.height)
            }

            if let _ = badgeView.superview {
                let size = badgeView.sizeThatFits(frame.size)
                if #available(iOS 11.0, *), isWide {
                    badgeView.frame = CGRect(origin: CGPoint(x: imageView.frame.midX - 3 + badgeOffset.horizontal, y: imageView.frame.midY + 3 + badgeOffset.vertical), size: size)
                } else {
                    badgeView.frame = CGRect(origin: CGPoint(x: w / 2.0 + badgeOffset.horizontal, y: h / 2.0 + badgeOffset.vertical), size: size)
                }
                badgeView.setNeedsLayout()
            }

        } else {
            if !imageView.isHidden, !titleLabel.isHidden {
                titleLabel.sizeToFit()
                imageView.sizeToFit()
                titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                          y: h - titleLabel.bounds.size.height - 1.0,
                                          width: titleLabel.bounds.size.width,
                                          height: titleLabel.bounds.size.height)
                imageView.frame = CGRect(x: (w - imageView.bounds.size.width) / 2.0,
                                         y: (h - imageView.bounds.size.height) / 2.0 - 6.0,
                                         width: imageView.bounds.size.width,
                                         height: imageView.bounds.size.height)
            } else if !imageView.isHidden {
                imageView.sizeToFit()
                imageView.center = CGPoint(x: w / 2.0, y: h / 2.0)
            } else if !titleLabel.isHidden {
                titleLabel.sizeToFit()
                titleLabel.center = CGPoint(x: w / 2.0, y: h / 2.0)
            }

            if let _ = badgeView.superview {
                let size = badgeView.sizeThatFits(frame.size)
                badgeView.frame = CGRect(origin: CGPoint(x: w / 2.0 + badgeOffset.horizontal, y: h / 2.0 + badgeOffset.vertical), size: size)
                badgeView.setNeedsLayout()
            }
        }
    }

    // MARK: - INTERNAL METHODS

    internal final func select(animated: Bool, completion: (() -> Void)?) {
        selected = true
        if highlightEnabled, highlighted {
            highlighted = false
            dehighlightAnimation(animated: animated, completion: { [weak self] in
                self?.updateDisplay()
                self?.selectAnimation(animated: animated, completion: completion)
            })
        } else {
            updateDisplay()
            selectAnimation(animated: animated, completion: completion)
        }
    }

    internal final func deselect(animated: Bool, completion: (() -> Void)?) {
        selected = false
        updateDisplay()
        deselectAnimation(animated: animated, completion: completion)
    }

    internal final func reselect(animated: Bool, completion: (() -> Void)?) {
        if selected == false {
            select(animated: animated, completion: completion)
        } else {
            if highlightEnabled, highlighted {
                highlighted = false
                dehighlightAnimation(animated: animated, completion: { [weak self] in
                    self?.reselectAnimation(animated: animated, completion: completion)
                })
            } else {
                reselectAnimation(animated: animated, completion: completion)
            }
        }
    }

    internal final func highlight(animated: Bool, completion: (() -> Void)?) {
        if !highlightEnabled {
            return
        }
        if highlighted == true {
            return
        }
        highlighted = true
        highlightAnimation(animated: animated, completion: completion)
    }

    internal final func dehighlight(animated: Bool, completion: (() -> Void)?) {
        if !highlightEnabled {
            return
        }
        if !highlighted {
            return
        }
        highlighted = false
        dehighlightAnimation(animated: animated, completion: completion)
    }

    internal func badgeChanged(animated: Bool, completion: (() -> Void)?) {
        badgeChangedAnimation(animated: animated, completion: completion)
    }

    // MARK: - ANIMATION METHODS

    open func selectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    open func deselectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    open func reselectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    open func highlightAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    open func dehighlightAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    open func badgeChangedAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }
}
