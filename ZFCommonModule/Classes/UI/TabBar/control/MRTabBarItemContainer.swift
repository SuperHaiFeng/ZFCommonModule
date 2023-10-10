//
//  MRTabBarItemContainer.swift
//  PopVoiceLive
//
//  Created by 董帅军 on 2020/3/30.
//  Copyright © 2020 Talla. All rights reserved.
//

import UIKit

internal class MRTabBarItemContainer: UIControl {
    internal init(_ target: AnyObject?, tag: Int) {
        super.init(frame: CGRect.zero)
        self.tag = tag
        addTarget(target, action: #selector(MRTabBar.selectAction(_:)), for: .touchUpInside)
        addTarget(target, action: #selector(MRTabBar.highlightAction(_:)), for: .touchDown)
        addTarget(target, action: #selector(MRTabBar.highlightAction(_:)), for: .touchDragEnter)
        addTarget(target, action: #selector(MRTabBar.dehighlightAction(_:)), for: .touchDragExit)
        backgroundColor = .clear
        isAccessibilityElement = true
    }

    internal required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews {
            if let subview = subview as? MRTabBarItemContentView {
                subview.frame = CGRect(x: subview.insets.left, y: subview.insets.top, width: bounds.size.width - subview.insets.left - subview.insets.right, height: bounds.size.height - subview.insets.top - subview.insets.bottom)
                subview.updateLayout()
            }
        }
    }

    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subview in subviews {
                if subview.point(inside: CGPoint(x: point.x - subview.frame.origin.x, y: point.y - subview.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }
}
