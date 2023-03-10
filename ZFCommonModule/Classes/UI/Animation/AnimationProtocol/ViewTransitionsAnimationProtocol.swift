//
//  ViewTransitionsAnimationProtocol.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/15.
//

import UIKit

public protocol ViewTransitionsAnimationProtocol {
    /// 动画完成或失败回调
    /// start ：动画开始完成  disappear：动画消失完成
    var delegate: Delegate<(start: Bool, disappear: Bool), Void>? { get }
    
    /// 动画时间
    var duration: CGFloat { get }
    /// 开始执行动画
    func startAnimation(target: UIView)
    
    /// 消失动画
    func disappearAnimation(target: UIView)
}

