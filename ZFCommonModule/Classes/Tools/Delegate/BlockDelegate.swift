//
//  BlockDelegate.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

/// 作为必包使用，可替代[weak self]来防止retain cycle
/// 使用方式
/// let onConfirmInput = Delegate<String?, Void>()
/// onConfirmInput.call(inputTextField.text)
/// onConfirmInput.delegate(on: self) { (self, text) in
///    self.textLabel.text = text
/// }
/// 由于使用了遮蔽变量 self，在闭包中的 self 其实是这个遮蔽变量，而非原本的 self。这样要求我们比较小心，否则可能造成意外的循环引用。
/// 在使用时delegate方法中(self, text)的self一定要写，不然会产生retain cycle
public class Delegate<Input, Output> {
    public init() {}
    
    private var closure: ((Input) -> Output?)?
    public func delegate<T: AnyObject>(on target: T, closure: ((T, Input) -> Output)?) {
        self.closure = { [weak target] input in
            guard let target = target else { return nil }
            return closure?(target, input)
        }
    }
    
    @discardableResult
    public func call(_ input: Input) -> Output? {
        return closure?(input)
    }
    
    /// swuft 5.2 引入了 callAsFunction 可以直接调用实例的方式调用call方法 比如：onConfirmInput(inputTextField.text)
    @discardableResult
    public func callAsFunction(_ input: Input) -> Output? {
        return closure?(input)
    }
}

public extension Delegate where Input == Void {
    @discardableResult
    func call() -> Output? {
        return call(())
    }
}
