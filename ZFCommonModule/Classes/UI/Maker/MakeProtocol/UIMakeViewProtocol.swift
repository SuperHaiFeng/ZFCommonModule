//
//  UIMakeViewProtocol.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

public protocol UIMakeViewProtocol where Self: UIView {
    
    /// 背景颜色
    func backColor(_ backColor: UIColor) -> Self
    
    /// 圆角大小
    func corner(_ corner: CGFloat) -> Self
    
    /// 边框颜色
    func borderColor(_ color: UIColor) -> Self
    
    /// 边框大小
    func borderWidth(_ width: CGFloat) -> Self
    
    ///是否是独占的，意思是操作本空间，其他空间不能操作
    func exclusiveTouch(_ value: Bool) -> Self
}

public extension UIMakeViewProtocol {
    /// 背景颜色
    @discardableResult
    func backColor(_ backColor: UIColor) -> Self {
        self.backgroundColor = backColor
        return self
    }
    
    /// 圆角大小
    @discardableResult
    func corner(_ corner: CGFloat) -> Self {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
        return self
    }
    
    /// 边框大小
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        self.layer.borderWidth = width
        return self
    }
    
    /// 边框颜色
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        return self
    }
    
    ///是否是独占的，意思是操作本空间，其他空间不能操作
    @discardableResult
    func exclusiveTouch(_ value: Bool) -> Self {
        self.isExclusiveTouch = value
        return self
    }
}

extension UIView: UIMakeViewProtocol { }
