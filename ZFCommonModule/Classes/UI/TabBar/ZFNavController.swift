//
//  ZFNavController.swift
//  ZFCommonModule
//
//  Created by macode on 2023/10/1.
//

import UIKit

open class ZFNavController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    public var opaqueAppearanceObj: AnyObject? = nil
    public var transparentAppearanceObj: AnyObject? = nil
    public var defaultAppearanceObj: AnyObject? = nil
    
    open override var shouldAutorotate: Bool {
        return viewControllers.last?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.isTranslucent = false
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            appearance.shadowColor = nil
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.black]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            opaqueAppearanceObj = appearance
            
            let tranAppearance = UINavigationBarAppearance()
            tranAppearance.configureWithTransparentBackground()
            tranAppearance.backgroundImage = UIImage()
            tranAppearance.shadowImage = UIImage()
            tranAppearance.shadowColor = nil
            tranAppearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.black]
            transparentAppearanceObj = tranAppearance
            
            let defaultAppearance = UINavigationBarAppearance()
            defaultAppearance.configureWithDefaultBackground()
            defaultAppearanceObj = defaultAppearance
        } else {
            navigationBar.barTintColor = .white
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.black]
        }
    }
    
    public func makeNavigationBarTransparent() {
        navigationBar.isTranslucent = true
        if #available(iOS 15, *), let tranAppearance = transparentAppearanceObj as? UINavigationBarAppearance {
            navigationBar.standardAppearance = tranAppearance
            navigationBar.scrollEdgeAppearance = tranAppearance
        } else {
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
    }
    
    public func makeNavigationBarOpaque(with color: UIColor) {
        navigationBar.isTranslucent = false
        if #available(iOS 15, *), let opaqueAppearance = opaqueAppearanceObj as? UINavigationBarAppearance {
            opaqueAppearance.backgroundColor = color
            navigationBar.standardAppearance = opaqueAppearance
            navigationBar.scrollEdgeAppearance = opaqueAppearance
        } else {
            navigationBar.barTintColor = color
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        self.navigationBar.isTranslucent = false
        super.viewDidLoad()
        //        self.delegate = self
        // Do any additional setup after loading the view.
        self.interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.semanticContentAttribute = UIView.appearance().semanticContentAttribute
        self.view.semanticContentAttribute = UIView.appearance().semanticContentAttribute
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1{
            return false
        }
        return true
    }
}
