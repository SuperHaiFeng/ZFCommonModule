//
//  GlobalVars.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/15.
//

import UIKit

/// 带有一个泛型参数T
public typealias CommonCallback<T> = (T) -> Void

public let ScreenWidth = UIScreen.main.bounds.width
public let ScreenHeight = UIScreen.main.bounds.height

public var StatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height

public var SafeAreaInsets: UIEdgeInsets = {
    if let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets
    }
    return UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
}()
