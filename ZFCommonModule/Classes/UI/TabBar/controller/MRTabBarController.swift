//
//  MRTabBarController.swift
//  PopVoiceLive
//
//  Created by 董帅军 on 2020/3/30.
//  Copyright © 2020 Talla. All rights reserved.
//

import UIKit

/// 是否需要自定义点击事件回调类型
public typealias MRTabBarControllerShouldHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> (Bool))
/// 自定义点击事件回调类型
public typealias MRTabBarControllerDidHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> Void)


/// TabBar Controller, 如果是RTL语言则会把Controller的顺序进行翻转, 并且把默认的选中tab也进行修改. see : https://github.com/eggswift/ESTabBarController
/// 子类 override provideControllers 函数提供每个tab对应的 Controller
///
/// Demo:
///    主页面有 home、me 2个 tab
//    class MainController: MRTabBarController {
//
//        override func provideControllers() -> [UIViewController]? {
//            // home tab
//            let homeTab = HomeTabController()
//            homeTab.tabBarItem = MRTabBarItem(renderingMode: UIImage.RenderingMode.alwaysOriginal,
//                                                 image: UIImage(named: "icon_tabbar_hostwall_normal"),
//                                                 selectedImage: UIImage(named: "icon_tabbar_hostwall_selected"), tag: 0)
//
//            // me tab
//            let meTab = MeTabController()
//            meTab.tabBarItem = MRTabBarItem(renderingMode: UIImage.RenderingMode.alwaysOriginal,
//                                               image: UIImage(named: "icon_tabbar_me_normal"),
//                                               selectedImage: UIImage(named: "icon_tabbar_me_selected"), tag: 2)
//            return [homeTab, meTab]
//        }
//    }

// MARK: - 老的类名为: DSJTabBarController

open class MRTabBarController: UITabBarController, MRTabBarDelegate {
    /// 打印异常
    public static func printError(_ description: String) {
        #if DEBUG
            print("ERROR: ESTabBarController catch an error '\(description)' \n")
        #endif
    }

    /// 当前tabBarController是否存在"More"tab
    public static func isShowingMore(_ tabBarController: UITabBarController?) -> Bool {
        return tabBarController?.moreNavigationController.parent != nil
    }

    /// Ignore next selection or not.
    fileprivate var ignoreNextSelection = false

    /// Should hijack select action or not.
    open var shouldHijackHandler: MRTabBarControllerShouldHijackHandler?
    /// Hijack select action.
    open var didHijackHandler: MRTabBarControllerDidHijackHandler?

    /// Observer tabBarController's selectedViewController. change its selection when it will-set.
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                // if newValue == nil ...
                return
            }
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? MRTabBar, let items = tabBar.items, let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            let value = (MRTabBarController.isShowingMore(self) && index > items.count - 1) ? items.count - 1 : index
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }

    /// Observer tabBarController's selectedIndex. change its selection when it will-set.
    open override var selectedIndex: Int {
        willSet {
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? MRTabBar, let items = tabBar.items else {
                return
            }
            let value = (MRTabBarController.isShowingMore(self) && newValue > items.count - 1) ? items.count - 1 : newValue
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }

    /// Customize set tabBar use KVC.
    open override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = { () -> MRTabBar in
            let tabBar = MRTabBar()
            tabBar.delegate = self
            tabBar.customDelegate = self
            tabBar.tabBarController = self
            return tabBar
        }()
        setValue(tabBar, forKey: "tabBar")
        
        // initialize tab's controllers
        if let originalVcs = self.provideControllers() {
            /// support RTL
            self.viewControllers = originalVcs
            self.selectedIndex = self.selectedIndex
        }
    }
    
    /// provide tab's controllers
    open func provideControllers() -> [UIViewController]? {
        return nil
    }

    // MARK: - UITabBar delegate

    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return
        }
        if idx == tabBar.items!.count - 1, MRTabBarController.isShowingMore(self) {
            ignoreNextSelection = true
            selectedViewController = moreNavigationController
            return
        }
        if let vc = viewControllers?[idx] {
            ignoreNextSelection = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: vc)
        }
    }

    open override func tabBar(_ tabBar: UITabBar, willBeginCustomizing _: [UITabBarItem]) {
        if let tabBar = tabBar as? MRTabBar {
            tabBar.updateLayout()
        }
    }

    open override func tabBar(_ tabBar: UITabBar, didEndCustomizing _: [UITabBarItem], changed _: Bool) {
        if let tabBar = tabBar as? MRTabBar {
            tabBar.updateLayout()
        }
    }

    // MARK: - ESTabBar delegate

    internal func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }

    internal func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            return shouldHijackHandler?(self, vc, idx) ?? false
        }
        return false
    }

    internal func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem) {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            didHijackHandler?(self, vc, idx)
        }
    }
}
