//
//  PageboyViewPanel.swift
//  PopVoiceLive
//
//  Created by macode on 2023/2/17.
//  Copyright © 2023 YoYo. All rights reserved.
//

import UIKit

// pageboy容器视图回调代理
protocol PageboyPanelDelegate: NSObjectProtocol {
    /// pageboy滑动到某一页的回调
    /// - Parameter page: 某一页
    func pageboyScrollToPage(in page: Int)
}

// pageboy数据源代理
protocol PageboyPanelDataSource: NSObjectProtocol {
    /// 当前共有多少tab
    /// - Returns: <#description#>
    func pageboyNumberOfItems() -> Int
    /// 获取当前需要显示的view
    /// - Parameter index: tabbar对应的视图
    /// - Returns: <#description#>
    func pageboyView(for index: Int) -> PageboyContainer
}

/// pageboy容器显示
open class PageboyContainer: UIView {
    open func viewDidAppear() {}
}

class PageboyViewPanel: UIView {
    private lazy var collectionView: RTLCollectionView = {
        let layout = makeFlowLayout().direction(.horizontal).lineSpacing(0).interSpacing(0)
        return makeCollecView(.zero, layout)
            .delegate(self)
            .dataSource(self)
            .pageEnable(true)
            .showHorizontal(false)
            .backColor(.white)
            .register(["default": UICollectionViewCell.self])
    }()
    private weak var delegate: PageboyPanelDelegate? = nil
    private weak var dataSource: PageboyPanelDataSource? = nil
    
    private var cacheView: [Int: PageboyContainer] = [:]
    
    /// 当前显示内容的下标
    public private(set) var currentIndex: Int = 0
    
    /// 当前显示内容视图（如果本视图嵌套了tabman，则递归获取）
    public var currentPageboy: UIView? {
        get {
            return findCurrentPageBoy()
        }
    }
    
    private func findCurrentPageBoy() -> UIView? {
        guard let firstView = cacheView[currentIndex] else {
            return nil
        }
        if let tabmanPanel = firstView as? TabmanViewPanel {
            return tabmanPanel.currentPageboy
        } else {
            return firstView
        }
    }
    
    init(delegate: PageboyPanelDelegate, datasource: PageboyPanelDataSource) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
        self.dataSource = datasource
        loadSubviews()
    }
    
    public func clear() {
        cacheView.forEach({ $0.value.removeFromSuperview() })
        cacheView.removeAll()
        currentIndex = 0
        scrollToPage(page: 0)
        reloadDatas()
    }
    
    public func reloadDatas() {
        self.collectionView.reloadData()
    }
    
    public func loadSubviews() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func scrollToPage(page: Int) {
        collectionView.contentOffset = CGPoint(x: bounds.width * CGFloat(page), y: 0)
        if self.currentIndex != page {
            cacheView[page]?.viewDidAppear()
            self.currentIndex = page
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentX = scrollView.contentOffset.x
        let page = Int(contentX / bounds.width)
        self.delegate?.pageboyScrollToPage(in: page)
        if self.currentIndex != page {
            cacheView[page]?.viewDidAppear()
            self.currentIndex = page
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageboyViewPanel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.pageboyNumberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        if let view = cacheView[indexPath.row] ?? dataSource?.pageboyView(for: indexPath.row) {
            cell.contentView.addSubview(view)
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            cacheView[indexPath.row] = view
        }
        return cell 
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }
}
