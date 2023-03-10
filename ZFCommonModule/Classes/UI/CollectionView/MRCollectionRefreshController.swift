//
//  MRCollectionRefreshController.swift
//  Alamofire
//
//  Created by macode on 2022/1/20.
//

import MJRefresh
import UIKit
import SnapKit

/// CollectionView Controller
open class MRCollectionRefreshController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var collectionView: ZFCollectionView!
    public var datas: [CellModelProtocol] = []
    // table view的数据仓库, 用于从服务器端获取数据
    public var dataSetRepo: TableViewDataRepository?
    
    public var isHeadRefreshSupported: Bool {
        get {
            return _isHeadRefreshSupported
        }
        set {
            _isHeadRefreshSupported = newValue
            updateHeadRefreshState()
        }
    }
    
    public var isFootRefreshSupported: Bool {
        get {
            return _isFootRefreshSupported
        }
        set {
            _isFootRefreshSupported = newValue
            updateFootRefreshState()
        }
    }

    /// 页面启动时自动下拉刷新
    public var autoRefresh: Bool = true
    
    // MARK: - Override
    
    private var _isHeadRefreshSupported = true
    private var _isFootRefreshSupported = true
    
    public init(layout: ZFCollectionFlowLayout? = nil, repo: TableViewDataRepository? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.dataSetRepo = repo
        var collectionLayout = layout
        if collectionLayout == nil {
            collectionLayout = defaultCollectionLayout()
        }
        collectionView = ZFCollectionView(frame: CGRect.zero, collectionViewLayout: collectionLayout!)
            .backColor(.white)
            .showVertical(true)
            .delegate(self)
            .dataSource(self)
    }
    
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func defaultCollectionLayout() -> ZFCollectionFlowLayout {
        
        let layout = ZFCollectionFlowLayout()
            .lineSpacing(8)
            .interSpacing(8)
            .direction(.vertical)
            .sectionInset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        let width = (UIScreen.main.bounds.width - layout.minimumLineSpacing * 3) / 2
        layout.size(CGSize(width: width, height: width * 240 / 168))
        return layout
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        makeCollectionViewConstraints()
        updateHeadRefreshState()
        updateFootRefreshState()
    }
    
    open func makeCollectionViewConstraints() {
        collectionView.snp.makeConstraints { [weak self] make in
            make.edges.equalTo(self!.view)
        }
    }
    
    open func registerCell(_ cell: AnyClass, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    open func registerHeaderOrFootview(_ view: AnyClass, forSupplementaryViewOfKind: String, identifier: String) {
        collectionView.register(view, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: identifier)
    }
    
    open func reload() {
        collectionView?.reloadData()
    }
    
    open func pullDownToRefresh() {
        collectionView.mj_header?.beginRefreshing()
        collectionView.mj_footer?.resetNoMoreData()
        collectionView.mj_footer?.endRefreshing()
        
        self.dataSetRepo?.fetchData(callback: { [weak self] (newData) in
            self?.onFetchedDataSet(dataSet: newData)
        }) { [weak self] in
            self?.endPullRefresh()
        }
    }
    
    open func onFetchedDataSet(dataSet: [CellModelProtocol]) {
        if self.datas.count > 0 {
            self.datas.insert(contentsOf: dataSet, at: 0)
        } else {
            self.datas = dataSet
        }
        self.reload()
        self.endPullRefresh()
    }
    
    open func pullUpToRefresh() {
        self.endPullRefresh()
        self.dataSetRepo?.loadMoreData(callback: { [weak self] (newData) in
            self?.onLoadMoreDataSet(dataSet: newData)
        }) { [weak self] in
            self?.endPullRefresh()
        }
    }
    
    open func onLoadMoreDataSet(dataSet: [CellModelProtocol]) {
        self.datas += dataSet
        self.reload()
        self.endPullRefresh()
        if dataSet.count == 0 {
            noticeNoMoreData()
        }
    }
    
    open func endPullDownRefresh() {
        collectionView.mj_header?.endRefreshing()
        checkNoData()
    }
    
    open func endPullUpRefresh() {
        collectionView.mj_footer?.endRefreshing()
        checkNoData()
    }
    
    open func endPullRefresh() {
        collectionView.mj_header?.endRefreshing()
        collectionView.mj_footer?.endRefreshing()
        checkNoData()
    }
    
    open func noticeNoMoreData() {
        collectionView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    open func resetNoMore() {
        collectionView.mj_footer?.resetNoMoreData()
    }
    
    open func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return datas.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataModel = self.datas[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataModel.identifier, for: indexPath) as? MRCollectionViewCell {
            cell.loadData(dataModel)
            return cell
        }
        return UICollectionViewCell()
    }
    
    open func obtainCell(indexPath: IndexPath) -> MRCollectionViewCell?  {
        return self.collectionView.cellForItem(at: indexPath) as? MRCollectionViewCell
    }
    
    open func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        obtainCell(indexPath: indexPath)?.didSelect(nav: self.navigationController, collectionView: self.collectionView, didSelectRowAt: indexPath)
    }
    
    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize.zero
    }
    
    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection _: Int) -> CGSize {
        return CGSize.zero
    }
    
    // MARK: - update refresh state
    
    private func updateHeadRefreshState() {
        if collectionView == nil {
            return
        }
        if _isHeadRefreshSupported {
            if collectionView.mj_header == nil {
                MJRefreshNormalHeader { [weak self] in
                    self?.pullDownToRefresh()
                }.autoChangeTransparency(true)
                    .link(to: collectionView)
                if self.autoRefresh {
                    self.collectionView?.mj_header?.beginRefreshing()
                }
            }
        } else {
            collectionView.mj_header?.removeFromSuperview()
        }
    }
    
    private func tryAutoRefresh() {
        if self.autoRefresh {
            DispatchQueue.main.async {
                self.pullDownToRefresh()
            }
        }
    }
    
    private func updateFootRefreshState() {
        if collectionView == nil {
            return
        }
        if _isFootRefreshSupported {
            if collectionView.mj_footer == nil {
                MJRefreshAutoFooter { [weak self] in
                    self?.pullUpToRefresh()
                }.autoChangeTransparency(true)
                    .link(to: collectionView)
            }
        } else {
            collectionView.mj_footer?.removeFromSuperview()
        }
    }
    
    public func getCollectionView() -> UICollectionView {
        return collectionView
    }
    
    // MARK: - NoDataTip
    
    open func checkNoData() {
        if self.datas.count > 0 {
//            self.hideNoDataTipView()
        } else {
            self.showNoDataTipView()
        }
    }
    
    open func showNoDataTipView() {
//        if !isNoDataTipViewShouldShow {
//            return
//        }
//        super.showNoDataTipView()
    }
    
    open func onClickNoDataView() {
        self.pullDownToRefresh()
    }
}
