//
//  LLabelMaker.swift
//  Alamofire
//
//  Created by macode on 2022/9/2.
//

import UIKit

private var conf: Conf = {
    $0
}(Conf())

public class LLabelMaker: NSObject {
    private var label: LLabel = LLabel()

    override init() {
        super.init()
        conf.clear()
    }

    /// 字体颜色
    open func textColor(_ color: UIColor) -> LLabelMaker {
        conf.textColor = color
        return self
    }

    /// 文本信息
    open func text(_ text: String) -> LLabelMaker {
        conf.text = text
        return self
    }
    
    /// 设置富文本
    public func attrTitle(_ attr: NSAttributedString) -> LLabelMaker {
        conf.attrText = attr
        return self
    }

    /// 字体大小
    open func fontSize(_ size: CGFloat) -> LLabelMaker {
        conf.fontSize = size
        return self
    }
    
    open func font(_ font: UIFont) -> LLabelMaker {
        conf.font = font
        return self
    }

    /// 字体权重
    open func fontWeight(_ weight: FontWeight) -> LLabelMaker {
        if #available(iOS 8.2, *) {
            conf.fontWeight = getFontWeight(weight)
        }
        return self
    }

    /// 字体居
    open func alignment(_ alignment: NSTextAlignment) -> LLabelMaker {
        conf.alignment = alignment
        return self
    }

    /// 背景颜色
    open func backColor(_ backColor: UIColor) -> LLabelMaker {
        conf.backColor = backColor
        return self
    }

    /// 圆角大小
    open func corner(_ corner: CGFloat) -> LLabelMaker {
        conf.corner = corner
        return self
    }

    /// 边距大小
    open func paddingEdge(_ edge: UIEdgeInsets) -> LLabelMaker {
        conf.padingEdge = edge
        return self
    }

    /// 最后执行
    open func maker() -> LLabel {
        label.textColor = conf.textColor
        label.text = conf.text
        if conf.fontWeight != nil {
            if #available(iOS 8.2, *) {
                label.font = UIFont.systemFont(ofSize: conf.fontSize, weight: conf.fontWeight!)
            } else {
                label.font = UIFont.systemFont(ofSize: conf.fontSize)
            }
        } else {
            label.font = UIFont.systemFont(ofSize: conf.fontSize)
        }
        label.textAlignment = conf.alignment

        if conf.backColor != nil {
            label.backgroundColor = conf.backColor
        }

        if conf.corner != nil {
            label.layer.cornerRadius = conf.corner!
            label.clipsToBounds = true
        }
        if conf.font != nil {
            label.font = conf.font
        }
        
        if conf.attrText != nil {
            label.attributedText = conf.attrText
        }

        label.paddingEdge = conf.padingEdge
        return label
    }
}

class Conf: NSObject {
    open var textColor: UIColor = UIColor.black
    open var text: String = ""
    open var fontSize: CGFloat = 0.0
    open var font: UIFont?
    open var fontWeight: UIFont.Weight?
    open var alignment: NSTextAlignment = .left
    open var backColor: UIColor?
    open var corner: CGFloat?
    open var padingEdge: UIEdgeInsets = UIEdgeInsets.zero
    open var attrText: NSAttributedString?

    open func clear() {
        textColor = UIColor.black
        text = ""
        fontSize = 0.0
        fontWeight = nil
        alignment = .left
        backColor = UIColor.clear
        corner = 0
        font = nil
        padingEdge = UIEdgeInsets.zero
        attrText = nil
    }

    override init() {}
}
