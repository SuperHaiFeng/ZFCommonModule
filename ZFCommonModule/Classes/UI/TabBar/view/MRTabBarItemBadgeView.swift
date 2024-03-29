//
//  MRTabBarItemBadgeView.swift
//  PopVoiceLive
//
//  Created by 董帅军 on 2020/3/30.
//  Copyright © 2020 Talla. All rights reserved.
//

import UIKit

/*
 * ESTabBarItemBadgeView
 * 这个类定义了item中使用的badge视图样式，默认为ESTabBarItemBadgeView类对象。
 * 你可以设置ESTabBarItemContentView的badgeView属性为自定义的ESTabBarItemBadgeView子类，这样就可以轻松实现 自定义通知样式了。
 */
open class MRTabBarItemBadgeView: UIView {
    /// 默认颜色
    public static var defaultBadgeColor = UIColor(red: 255.0 / 255.0, green: 59.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)

    /// Badge color
    open var badgeColor: UIColor? = defaultBadgeColor {
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }

    /// Badge value, supprot nil, "", "1", "someText". Hidden when nil. Show Little dot style when "".
    open var badgeValue: String? {
        didSet {
            badgeLabel.text = badgeValue
        }
    }

    /// Image view
    open var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        return imageView
    }()

    /// 显示badgeValue的Label
    open var badgeLabel: UILabel = {
        let badgeLabel = UILabel(frame: CGRect.zero)
        badgeLabel.backgroundColor = .clear
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 13.0)
        badgeLabel.textAlignment = .center
        return badgeLabel
    }()

    /// Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(badgeLabel)
        imageView.backgroundColor = badgeColor
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     *  通过layoutSubviews()布局子视图，你可以通过重写此方法实现自定义布局。
     **/
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let badgeValue = badgeValue else {
            imageView.isHidden = true
            badgeLabel.isHidden = true
            return
        }

        imageView.isHidden = false
        badgeLabel.isHidden = false

        if badgeValue == "" {
            imageView.frame = CGRect(origin: CGPoint(x: (bounds.size.width - 8.0) / 2.0, y: (bounds.size.height - 8.0) / 2.0), size: CGSize(width: 8.0, height: 8.0))
        } else {
            imageView.frame = bounds
        }
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0
        badgeLabel.sizeToFit()
        badgeLabel.center = imageView.center
    }

    /*
     *  通过此方法计算badge视图需要占用父视图的frame大小，通过重写此方法可以自定义badge视图的大小。
     *  如果你需要自定义badge视图在Content中的位置，可以设置Content的badgeOffset属性。
     */
    open override func sizeThatFits(_: CGSize) -> CGSize {
        guard let _ = badgeValue else {
            return CGSize(width: 18.0, height: 18.0)
        }
        let textSize = badgeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(18.0, textSize.width + 10.0), height: 18.0)
    }
}
