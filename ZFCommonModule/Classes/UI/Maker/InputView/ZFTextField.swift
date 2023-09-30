//
//  ZFTextField.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

public enum TextFieldDirection {
    case left
    case right
    case all
}

public class ZFTextField: UITextField {
    
}

extension ZFTextField {
    /// 字体
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    /// 字体颜色
    @discardableResult
    public func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    /// 光标颜色
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    /// 边距
    @discardableResult
    public func padding(_ padding: CGFloat, _ direction: TextFieldDirection) -> Self {
        if direction == .left {
            self.leftViewMode = .always
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
        } else if direction == .right {
            self.rightViewMode = .always
            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
        } else {
            _ = self.padding(padding, .left)
            return self.padding(padding, .right)
        }
        return self
    }
    
    /// 设置占位符
    @discardableResult
    public func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    /// 设置占位符
    @discardableResult
    public func placeholder(_ attr: NSAttributedString) -> Self {
        self.attributedPlaceholder = attr
        return self
    }
    
    /// 设置文本对齐方式
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    /// 设置删除按钮
    @discardableResult
    public func clear(_ mode: UITextField.ViewMode) -> Self {
        self.clearButtonMode = mode
        return self
    }
    
    @discardableResult
    public func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        self.borderStyle = style
        return self
    }
    
    @discardableResult
    public func attributedPlaceholder(_ attr: NSAttributedString) -> Self {
        self.attributedPlaceholder = attr
        return self
    }
    
    @discardableResult
    public func clearsOnBeginEditing(_ value: Bool) -> Self {
        self.clearsOnBeginEditing = value
        return self
    }
    
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = value
        return self
    }
    
    @discardableResult
    public func minimumFontSize(_ size: CGFloat) -> Self {
        self.minimumFontSize = size
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITextFieldDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func background(_ image: UIImage) -> Self {
        self.background = image
        return self
    }
    
    @discardableResult
    public func disabledBackground(_ image: UIImage) -> Self {
        self.disabledBackground = image
        return self
    }
    
    @discardableResult
    public func inputView(_ view: UIView) -> Self {
        self.inputView = view
        return self
    }
    
    @discardableResult
    public func clearsOnInsertion(_ value: Bool) -> Self {
        self.clearsOnInsertion = value
        return self
    }
    
    @discardableResult
    public func keyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }
    
    @discardableResult
    public func isSecureTextEntry(_ value: Bool) -> Self {
        self.isSecureTextEntry = value
        return self
    }
}
