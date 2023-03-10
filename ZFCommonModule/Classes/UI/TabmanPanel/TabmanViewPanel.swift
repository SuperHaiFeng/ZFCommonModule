//
//  TabmanViewPanel.swift
//  PopVoiceLive
//
//  Created by macode on 2023/2/17.
//  Copyright © 2023 YoYo. All rights reserved.
//

import UIKit
import SnapKit
import Pageboy
import Tabman

public typealias ImageBar = TMBarView<TMHorizontalBarLayout, ImageBarButton, TMBarIndicator.None>

/// 基于tabman的左右滑动视图，类似礼物面板，基于UIView封装
/// 和PageboyViewPanel配合使用
open class TabmanViewPanel: PageboyContainer, TMBarDelegate, TMBarDataSource, PageboyPanelDataSource {
    public private(set) var bars = [TMBar]()
    public var pageCount: Int {
        barItems.count
    }
    public internal(set) var currentPosition: CGPoint = .zero
    public var pageBar: ImageBar?
    
    private lazy var pageboyPanel: PageboyViewPanel = {
        return PageboyViewPanel(delegate: self, datasource: self)
    }()
    
    /// tabman数据源
    private var barItems: [TMBarItemable] = []
    
    public var barItemables: [TMBarItemable] {
        barItems
    }
    
    /// 当前下标
    public private(set) var currentIndex: Int = 0
    
    public var currentPageboy: UIView? {
        get { return pageboyPanel.currentPageboy }
    }
    
    /// 请调用 init(barItems: [TMBarItemable])
    init() {
        super.init(frame: CGRect.zero)
    }
    
    init(barItems: [TMBarItemable]) {
        super.init(frame: CGRect.zero)
        self.barItems = barItems
        loadSubviews()
    }
    
    public func loadSubviews() {
        loadBar()
        loadPageboyView { make in
            self.reloadPageboyConstraint(make: make)
        }
    }
    
    /// 重新刷新tab内容
    /// - Parameter items: <#items description#>
    public func reloadTabs(items: [TMBarItemable]) {
        self.barItems = items
        self.pageboyPanel.clear()
        
        guard let bar = pageBar else { return }
        updateBar(bar, to: 0, animated: false)
        
        guard pageCount > 0 else { return }
        pageBar?.reloadData(at: 0...pageCount - 1, context: .full)
    }
    
    private func loadPageboyView(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.addSubview(pageboyPanel)
        self.pageboyPanel.snp.makeConstraints(closure)
    }
    
    /// 默认图片bar，如需修改需要重写此方法
    public func loadBar() {
        pageBar = ImageBar()
        pageBar?.delegate = self
        pageBar?.layout.contentInset = UIEdgeInsets.zero
        pageBar?.layout.contentMode = .intrinsic
        pageBar?.layout.interButtonSpacing = 0
        pageBar?.layout.alignment = .leading
        pageBar?.backgroundView.style = .flat(color: UIColor.white)
        
        addBar(pageBar!, toView: self, dataSource: self) { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    public func reloadPageboyConstraint(make: ConstraintMaker) {
        make.leading.bottom.trailing.equalToSuperview()
        make.top.equalTo(44)
    }
        
    public func addBar(_ bar: TMBar,
                       toView: UIView,
                       dataSource: TMBarDataSource,
                       layout: (_ make: ConstraintMaker) -> Void) {
        
        bar.dataSource = dataSource
        bar.delegate = self
        
        if bars.contains(where: { $0 === bar }) == false {
            bars.append(bar)
        }
        toView.addSubview(bar)
        bar.snp.makeConstraints(layout)
        
        updateBar(bar, to: currentPosition.x, animated: false)
        
        guard pageCount > 0 else { return }
        bar.reloadData(at: 0...pageCount - 1, context: .full)
    }
    
    /// TMBarDelegate
    public func bar(_ bar: TMBar,
             didRequestScrollTo index: Int) {
        updateActiveBars(to: CGFloat(index), animated: true)
        pageboyPanel.scrollToPage(page: index)
    }
    
    /// TMBarDataSource
    public func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return barItems[index]
    }
    
    /// 返回pageboy视图
    /// - Parameter index: 下标
    /// - Returns: 返回基于UIView的视图，这个方法必须重写，不然会返回默认空视图
    open func pageboyView(for index: Int) -> PageboyContainer {
        let view = PageboyContainer()
        view.backgroundColor = UIColor.randomColor()
        return view
    }
    
    func pageboyNumberOfItems() -> Int {
        return self.pageCount
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabmanViewPanel: PageboyPanelDelegate {
    
    func pageboyScrollToPage(in page: Int) {
        updateActiveBars(to: CGFloat(page), animated: true)
    }
}

extension TabmanViewPanel {
    func updateActiveBars(to position: CGFloat?,
                          direction: PageboyViewController.NavigationDirection = .neutral,
                          animated: Bool) {
        bars.forEach({ self.updateBar($0, to: position,
                                            direction: direction,
                                            animated: animated) })
    }
    
    func updateBar(_ bar: TMBar,
                   to position: CGFloat?,
                   direction: PageboyViewController.NavigationDirection = .neutral,
                   animated: Bool) {
        let position = position ?? 0.0
        let capacity = self.pageCount
        let animation = TMAnimation(isEnabled: animated,
                                             duration: 0.25)
        bar.update(for: position,
                   capacity: capacity,
                   direction: updateDirection(for: direction),
                   animation: animation)
    }
    
    func updateDirection(for navigationDirection: PageboyViewController.NavigationDirection) -> TMBarUpdateDirection {
        switch navigationDirection {
        case .forward:
            return .forward
        case .neutral:
            return .none
        case .reverse:
            return .reverse
        }
    }
}
