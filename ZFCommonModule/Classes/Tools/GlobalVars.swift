//
//  GlobalVars.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/15.
//

import UIKit

/// 带有一个泛型参数T
public typealias CommonCallback<T> = (T) -> Void

/// 屏幕宽度
public let ScreenWidth = UIScreen.main.bounds.width
/// 屏幕高度
public let ScreenHeight = UIScreen.main.bounds.height

/// 状态栏高度
public let StatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height

/// 安全区间距
public var SafeAreaInsets: UIEdgeInsets = {
    if let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets
    }
    return UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
}()

/// 导航栏总高
public let NavigationHeight: CGFloat = StatusBarHeight + 44
