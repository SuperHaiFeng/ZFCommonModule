//
//  DialogBackView.swift
//  Alamofire
//
//  Created by macode on 2022/9/15.
//

import UIKit
import RxSwift

/// 对话消失的协议，每个加入到DialogBackView对话内容视图都必须实现这个协议，不然点击视图内容中的让消失的事件不会起作用
public protocol DialogContentDisappear where Self: UIView {
    /// 视图内容中需要让对话框消失时调用
    var disappear: Delegate<Bool, Void> { get }
    
    /// 视图将消失 添加滑动手势时可以以此来判断状态
    func viewWillDisappear(disappear: Bool)
}

extension DialogContentDisappear {
    public func viewWillDisappear(disappear: Bool) {}
}

/// 内容布局方向
public enum contentPosition {
    /// 吸顶布局
    case top
    /// 中间布局
    case center
    /// 吸底布局
    case bottom
    /// 吸左布局
    case left
    /// 吸右布局
    case right
}

/// 内容手势消失方向
public enum PanPosition {
    /// 向上滑动
    case top
    /// 向下滑动
    case bottom
    /// 向左滑动
    case left
    /// 向右滑动
    case right
    /// 所有方向都可滑动
    case all
}

/// 对话框参数
public struct DialogParams {
    /// 内容容器动画
    var contentAnimation: ViewTransitionsAnimationProtocol
    /// dialog背景动画
    var animation: ViewTransitionsAnimationProtocol
    /// 内容容器视图
    var contentView: DialogContentDisappear
    /// 内容容器位置
    var position: contentPosition
    
    /// 对话框参数
    /// - Parameters:
    ///   - contentAnimation: 内容容器动画
    ///   - animation: dialog背景动画
    ///   - contentView: 内容容器视图
    ///   - position: 内容容器位置
    public init(contentAnimation: ViewTransitionsAnimationProtocol, animation: ViewTransitionsAnimationProtocol, contentView: DialogContentDisappear, position: contentPosition) {
        self.contentAnimation = contentAnimation
        self.animation = animation
        self.contentView = contentView
        self.position = position
    }
    
    /// 对话框参数
    /// - Parameters:
    ///   - contentAnimation: 内容容器动画
    ///   - contentView: 内容容器视图
    ///   - position: 内容容器位置
    public init(contentAnimation: ViewTransitionsAnimationProtocol, contentView: DialogContentDisappear, position: contentPosition) {
        self.init(contentAnimation: contentAnimation, animation: LoomAnimation(), contentView: contentView, position: position)
    }
    
    /// 对话框参数
    /// - Parameters:
    ///   - contentAnimation: 内容容器动画
    ///   - contentView: 内容容器视图
    public init(contentAnimation: ViewTransitionsAnimationProtocol, contentView: DialogContentDisappear) {
        self.init(contentAnimation: contentAnimation, contentView: contentView, position: .bottom)
    }
}

/// 对话框背景视图
public class DialogBackView: UIView, UIGestureRecognizerDelegate {
    public let disposeBag = DisposeBag()
    private let params: DialogParams
    
    /// <#Description#>
    /// - Parameters:
    ///   - contentView: 主内容view
    ///   - contentAnimation: 主内容动画 默认放大缩小
    ///   - animation: 背景动画 默认隐现
    ///   - anchView: 锚点view，主内容view以此为锚点进行布局，在此view下面，如果没有锚视图，则以position进行布局
    public init(params: DialogParams, anchor anchView: UIView? = nil) {
        
        self.params = params
        super.init(frame: .zero)
        
        layoutContentView(anchView: anchView)
        
        bindEvent()
    }
    
    
    /// 布局主内容视图
    /// - Parameters:
    ///   - contentView: 内容视图
    ///   - anchView: 锚点视图
    private func layoutContentView(anchView: UIView? = nil) {
        addSubview(params.contentView)
        if let anchView = anchView {
            let anchFrame = anchView.convert(anchView.bounds, to: UIApplication.shared.keyWindow)
            params.contentView.snp.makeConstraints { make in
                make.top.equalTo(anchFrame.maxY)
                if anchFrame.midX == ScreenWidth / 2 {
                    make.centerX.equalTo(anchFrame.midX)
                } else if anchFrame.minX < ScreenWidth / 2 {
                    make.left.equalTo(anchFrame.minX)
                } else {
                    make.right.equalTo(anchFrame.maxX - ScreenWidth)
                }
            }
        } else {
            layoutContentWithPosition()
        }
    }
    
    /// 如果没有锚视图，那么就根据位置进行布局
    private func layoutContentWithPosition() {
        params.contentView.snp.makeConstraints { make in
            switch params.position {
                case .top:
                    make.top.centerX.equalToSuperview()
                case .center:
                    make.center.equalToSuperview()
                case .bottom:
                    make.bottom.centerX.equalToSuperview()
                case .left:
                    make.leading.centerY.equalToSuperview()
                case .right:
                    make.trailing.centerY.equalToSuperview()
            }
            if !params.contentView.frame.size.equalTo(.zero) {
                make.width.equalTo(params.contentView.frame.width)
                make.height.equalTo(params.contentView.frame.height)
            }
        }
    }
    
    /// 绑定事件
    private func bindEvent() {
        // 点击背景事件
//        self.rx.click.subscribe { [weak self] _ in
//            guard let self = self else { return }
//            self.disappearAnimation()
//        }.disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(disappearAnimation))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        params.contentView.disappear.delegate(on: self) { (self, disa) in
            if disa {
                self.disappearAnimation()
            }
        }
        
        // 动画消失后的事件
        params.contentAnimation.delegate?.delegate(on: self, closure: { (self, args) in
            if args.disappear {
                self.disappear()
            }
        })
    }
    
    open func showInWindow() -> Void {
        guard let view = UIApplication.shared.keyWindow else { return }
        showIn(view, frame: view.frame)
    }
    
    open func showIn(_ view: UIView, frame: CGRect) {
        guard self.superview == nil, view != self else { return }
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
        params.animation.startAnimation(target: self)
        params.contentAnimation.startAnimation(target: params.contentView)
    }
            
    /// 消失动画执行
    @objc public func disappearAnimation() {
        params.animation.disappearAnimation(target: self)
        params.contentAnimation.disappearAnimation(target: params.contentView)
    }
    
    /// 移除视图
    private func disappear() {
        params.contentView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer, let touchView = touch.view, touchView.isDescendant(of: params.contentView) {
            return false
        }
        return true
    }
    
    deinit {
        print("deinit dialog")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 以下是pan dissmiss手势属性
    private var containerPanDissmissPosition: PanPosition = .bottom
    private var containerPanDissmissEnabled: Bool = false
    private var containerBeginCenter: CGPoint = .zero
    // 是否震动过
    private var isImpacted: Bool = false
}

/// =**********************************************************  pan手势dismiss设置
extension DialogBackView {
    private var container: DialogContentDisappear {
        get { params.contentView }
    }
    
    /// pandismiss手势方向
    @discardableResult
    public func panDismiss(enabled: Bool, panPosition: PanPosition = .bottom) -> Self {
        self.containerPanDissmissPosition = panPosition
        self.containerPanDissmissEnabled = enabled
        if enabled {
            addPanGestureToContainer()
        } else {
            removePanGestureWithContainer()
        }
        return self
    }
    
    /// 添加pan手势，如果此view上有了pan手势就不再添加
    private func addPanGestureToContainer() {
        guard !(container.gestureRecognizers?.contains(where: { $0 is UIPanGestureRecognizer }) ?? false) else { return }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panDissmissEvent))
        pan.maximumNumberOfTouches = 1
        container.addGestureRecognizer(pan)
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEvent)))
    }
    
    @objc private func panDissmissEvent(ges: UIPanGestureRecognizer) {
        switch ges.state {
            case .began:
                containerBeginCenter = container.center
            case .changed:
                self.panChanged(ges: ges)
            case .ended:
                self.panEnded(ges: ges)
            default: break
        }
    }
    
    /// 滑动改变转换center
    private func transChangeCenter(transPoint: CGPoint) -> CGPoint {
        var curCenter = container.center
        switch containerPanDissmissPosition {
            case .top, .bottom:
                let y = transPoint.y
                curCenter.y = panCompare(curCenter.y + y, containerBeginCenter.y)
                return curCenter
            case .left, .right:
                let x = transPoint.x
                curCenter.x = panCompare(curCenter.x + x, containerBeginCenter.x)
                return curCenter
            case .all:
                curCenter.x = curCenter.x + transPoint.x
                curCenter.y = curCenter.y + transPoint.y
                return curCenter
        }
    }
    
    
    /// 滑动改变
    private func panChanged(ges: UIPanGestureRecognizer) {
        let transPoint = ges.translation(in: container)
        let curCenter = transChangeCenter(transPoint: transPoint)
        container.center =  curCenter
        ges.setTranslation(.zero, in: container)
        container.viewWillDisappear(disappear: panCanDisapear)
        if panCanDisapear {
            if !isImpacted {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                isImpacted = true
            }
        } else {
            isImpacted = false
        }
    }
    
    /// 滑动结束
    private func panEnded(ges: UIPanGestureRecognizer) {
        if panCanDisapear {
            container.disappear.call(true)
        } else {
            let velocity = ges.velocity(in: container)
            var overspeed: Bool = false
            switch containerPanDissmissPosition {
                case .top: overspeed = velocity.y < -800
                case .bottom: overspeed = velocity.y > 800
                case .left: overspeed = velocity.x < -800
                case .right: overspeed = velocity.x > 800
                case .all: overspeed = abs(velocity.x) > 800 || abs(velocity.y) > 800
            }
            if overspeed {
                container.disappear.call(true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.container.center = self.containerBeginCenter
                }
                isImpacted = false
            }
        }
    }
    
    /// 滑动比较
    private var panCompare: (_ x: CGFloat, _ y: CGFloat) -> CGFloat {
        get {
            switch containerPanDissmissPosition {
                case .top, .left: return min
                case .bottom, .right: return max
                case .all: return min
            }
        }
    }
    
    /// 是否可以消失
    private var panCanDisapear: Bool {
        get {
            switch containerPanDissmissPosition {
                case .left:
                    return (containerBeginCenter.x - container.center.x) > container.bounds.width / 4
                case .right:
                    return (container.center.x - containerBeginCenter.x) > container.bounds.width / 4
                case .top:
                    return (containerBeginCenter.y - container.center.y) > container.bounds.height / 4
                case .bottom:
                    return (container.center.y - containerBeginCenter.y) > container.bounds.height / 4
                case .all:
                    let xDiff = abs(containerBeginCenter.x - container.center.x)
                    let yDiff = abs(containerBeginCenter.y - container.center.y)
                    let disapear = xDiff > container.bounds.width / 4 || yDiff > container.bounds.height / 4
                    return disapear
            }
        }
    }
    
    @objc private func tapEvent() {}
    
    /// 这个方法是移除所有的pan手势
    private func removePanGestureWithContainer() {
        container.gestureRecognizers?.forEach({ gesture in
            if gesture is UIPanGestureRecognizer {
                container.removeGestureRecognizer(gesture)
            }
        })
    }
}
