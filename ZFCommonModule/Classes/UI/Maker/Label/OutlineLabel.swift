//
//  OutlineLabel.swift
//  ZFCommonModule
//
//  Created by macode on 2023/11/3.
//

import UIKit

/// 描边label
public class OutlinedLabel: UILabel {
    var textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private var strokColor = UIColor.black
    private var fillColor = UIColor.white
    
    public init(strokColor: UIColor, fillColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.strokColor = strokColor
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawText(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        context?.setLineWidth(2)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        self.textColor = self.strokColor
        super.drawText(in: rect.inset(by: textInsets))
                
        context?.setTextDrawingMode(.fill)
        context?.setLineJoin(.round)
        self.textColor = self.fillColor
        super.drawText(in: rect.inset(by: textInsets))
    }

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),limitedToNumberOfLines: numberOfLines)
            
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}
