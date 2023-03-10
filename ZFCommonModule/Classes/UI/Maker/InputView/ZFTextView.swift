//
//  ZFTextView.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/5.
//

import UIKit
import RxSwift
import RxCocoa

public class ZFTextView: UITextView {
    public let disposeBag = DisposeBag()
    private var placeholder: String = "" {
        didSet {
            if placeholder.count > 0 && placeholderLabel == nil {
                loadPlaceholder()
            } else {
                self.placeholderLabel?.text = placeholder
            }
        }
    }
    private var placeholderLabel: LLabel?

    private func loadPlaceholder() {
        placeholderLabel = makeLabel()
            .text(placeholder)
            .font(font ?? UIFont.systemFont(ofSize: 12))
            .textColor(UIColor(white: 0, alpha: 0.2))
            .maker().numberLines(0)
        addSubview(placeholderLabel!)
        let leading = textContainerInset.left == 0 ? textContainer.lineFragmentPadding : textContainerInset.left
        placeholderLabel?.snp.makeConstraints { make in
            make.leading.equalTo(leading)
            make.top.equalTo(textContainerInset.top)
            make.trailing.equalTo(-textContainerInset.right)
        }
        self.rx.text.orEmpty.compactMap({ $0.count > 0 }).subscribe { [weak self] notEmpty in
            self?.placeholderLabel?.isHidden = notEmpty
        }.disposed(by: disposeBag)
    }
    
}

extension ZFTextView {
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
    
    /// 设置文本输入偏移量
    @discardableResult
    public func textInset(_ inset: UIEdgeInsets) -> Self {
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = inset
        return self
    }
    
    /// 设置文本对齐方式
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    /// 设置占位符
    @discardableResult
    public func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    /// 设置占位符字体颜色
    @discardableResult
    public func placeholderColor(_ color: UIColor) -> Self {
        self.placeholderLabel?.textColor = color
        return self
    }
    
    @discardableResult
    public func selectedRange(_ range: NSRange) -> Self {
        self.selectedRange = range
        return self
    }
    
    @discardableResult
    public func isEditable(_ value: Bool) -> Self {
        self.isEditable = value
        return self
    }
    
    @discardableResult
    public func isSelectable(_ value: Bool) -> Self {
        self.isSelectable = value
        return self
    }
    
    @discardableResult
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        self.allowsEditingTextAttributes = value
        return self
    }
    
    @discardableResult
    public func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        self.dataDetectorTypes = types
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
    
    @available(iOS 13.0, *)
    @discardableResult
    public func usesStandardTextScaling(_ value: Bool) -> Self {
        self.usesStandardTextScaling = value
        return self
    }
}
