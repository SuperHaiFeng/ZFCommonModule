//
//  UIView+Ex.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

extension UIView {
    public func addCorners(bounds: CGRect, cornerRadii:CornerRadii){
       let path = createPathWithRoundedRect(bounds: bounds, cornerRadii:cornerRadii)
       let shapLayer = CAShapeLayer()
       shapLayer.frame = self.bounds
       shapLayer.path = path
       self.layer.mask = shapLayer
    }
    
    public struct CornerRadii {
        public var topLeft :CGFloat = 0
        public var topRight :CGFloat = 0
        public var bottomLeft :CGFloat = 0
        public var bottomRight :CGFloat = 0
        
        public init(_ topLeft: CGFloat, _ topRight: CGFloat, _ bottomLeft: CGFloat, _ bottomRight: CGFloat) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }
    }
    
    func createPathWithRoundedRect( bounds:CGRect,cornerRadii:CornerRadii) -> CGPath
    {
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY
        
        let topLeftCenterX = minX +  cornerRadii.topLeft
        let topLeftCenterY = minY + cornerRadii.topLeft
         
        let topRightCenterX = maxX - cornerRadii.topRight
        let topRightCenterY = minY + cornerRadii.topRight
        
        let bottomLeftCenterX = minX +  cornerRadii.bottomLeft
        let bottomLeftCenterY = maxY - cornerRadii.bottomLeft
         
        let bottomRightCenterX = maxX -  cornerRadii.bottomRight
        let bottomRightCenterY = maxY - cornerRadii.bottomRight
        
        let path :CGMutablePath = CGMutablePath();
         //topleft
        path.addArc(center: CGPoint(x: topLeftCenterX, y: topLeftCenterY), radius: cornerRadii.topLeft, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3 / 2, clockwise: false)
        //topright
        path.addArc(center: CGPoint(x: topRightCenterX, y: topRightCenterY), radius: cornerRadii.topRight, startAngle: CGFloat.pi * 3 / 2, endAngle: 0, clockwise: false)
        //bottomright
        path.addArc(center: CGPoint(x: bottomRightCenterX, y: bottomRightCenterY), radius: cornerRadii.bottomRight, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: false)
        //bottomleft
        path.addArc(center: CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY), radius: cornerRadii.bottomLeft, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: false)
        path.closeSubpath();
         return path;
    }
}

extension UIView {
    func addShadow(color: UIColor, offset: CGSize = .zero, radius: CGFloat = 3, opacity: Float = 0.15, scale: Bool = true) {
        if self.backgroundColor == .clear {
            self.backgroundColor = .white
        }
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
//        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

import RxSwift
import RxCocoa

typealias View = UIKit.UIView

/// add UITapGestureRecognizer for UIView and it's subclass
/// see UIControl's tap event
extension Reactive where Base: UIView {
    
    /// 使用click点击UIView是添加tag手势，只能点击，不能滑动，滑动就失去了跟踪事件，触发不了点击事件，想要在手指移动也能触发，请使用继承UIControl的UIVIew tap事件
    /// Reactive wrapper for `TouchUpInside` control event.
    public var click: ControlEvent<Void> {
        self.base.isUserInteractionEnabled = true
        return self.controlEvent(.touchUpInside)
    }
    
    /// Reactive wrapper for target action pattern.
    ///
    /// - parameter controlEvents: Filter for observed event types.
    public func controlEvent(_ controlEvents: UIControl.Event) -> ControlEvent<()> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
            MainScheduler.ensureRunningOnMainThread()
            
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            let controlTarget = ViewTarget(control: control, controlEvents: controlEvents) { _ in
                observer.on(.next(()))
            }
            
            return Disposables.create(with: controlTarget.dispose)
        }
        .take(until:deallocated)
        return ControlEvent(events: source)
    }
}


fileprivate class CustomRxTarget : NSObject
               , Disposable {
    
    private var retainSelf: CustomRxTarget?
    
    override init() {
        super.init()
        self.retainSelf = self

#if TRACE_RESOURCES
        _ = Resources.incrementTotal()
#endif

#if DEBUG
        MainScheduler.ensureRunningOnMainThread()
#endif
    }
    
    func dispose() {
#if DEBUG
        MainScheduler.ensureRunningOnMainThread()
#endif
        self.retainSelf = nil
    }

#if TRACE_RESOURCES
    deinit {
        _ = Resources.decrementTotal()
    }
#endif
}


// This should be only used from `MainScheduler`
fileprivate final class ViewTarget: CustomRxTarget {
    typealias Callback = (View) -> Void

    let selector: Selector = #selector(ViewTarget.eventHandler(_:))
    let tapGesture = UITapGestureRecognizer()
    
    weak var control: View?
#if os(iOS) || os(tvOS)
    let controlEvents: UIControl.Event
#endif
    var callback: Callback?
    #if os(iOS) || os(tvOS)
    init(control: View, controlEvents: UIControl.Event, callback: @escaping Callback) {
        MainScheduler.ensureRunningOnMainThread()

        self.control = control
        self.controlEvents = controlEvents
        self.callback = callback

        super.init()

        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: selector)
        self.control?.addGestureRecognizer(tapGesture)
        //control.addTarget(self, action: selector, for: controlEvents)

        let method = self.method(for: selector)
        if method == nil {
            fatalError("Can't find method")
        }
    }
#elseif os(macOS)
    init(control: Control, callback: @escaping Callback) {
        MainScheduler.ensureRunningOnMainThread()

        self.control = control
        self.callback = callback

        super.init()

        control.target = self
        control.action = self.selector

        let method = self.method(for: self.selector)
        if method == nil {
            rxFatalError("Can't find method")
        }
    }
#endif

    @objc func eventHandler(_ sender: View!) {
        if let callback = self.callback, let control = self.control {
            callback(control)
        }
    }

    override func dispose() {
        super.dispose()
#if os(iOS) || os(tvOS)
        self.control?.removeGestureRecognizer(tapGesture)
        //self.control?.removeTarget(self, action: self.selector, for: self.controlEvents)
#elseif os(macOS)
        self.control?.target = nil
        self.control?.action = nil
#endif
        self.callback = nil
    }
}

#if os(iOS)

extension Reactive where Base: UIControl {
    
    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}

#endif
