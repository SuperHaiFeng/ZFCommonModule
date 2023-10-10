//
//  MRTabBarItemMoreContentView.swift
//  PopVoiceLive
//
//  Created by 董帅军 on 2020/3/30.
//  Copyright © 2020 Talla. All rights reserved.
//

import UIKit

/// More Tab, 样式为图标为3个点, 下面为 More .
open class MRTabBarItemMoreContentView: MRTabBarItemContentView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        title = NSLocalizedString("More_TabBarItem", bundle: Bundle(for: MRTabBarController.self), comment: "")
        image = systemMoreCircleImage(highlighted: false)
        selectedImage = systemMoreCircleImage(highlighted: true)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func systemMoreCircleImage(highlighted isHighlighted: Bool) -> UIImage? {
        let image = UIImage()
        let circleDiameter = isHighlighted ? 5.0 : 4.0
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 32, height: 32), false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(1.0)
            for index in 0 ... 2 {
                let tmpRect = CGRect(x: 5.0 + 9.0 * Double(index), y: 14.0, width: circleDiameter, height: circleDiameter)
                context.addEllipse(in: tmpRect)
                image.draw(in: tmpRect)
            }
            if isHighlighted {
                context.setFillColor(UIColor.blue.cgColor)
                context.fillPath()
            } else {
                context.strokePath()
            }
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
}
