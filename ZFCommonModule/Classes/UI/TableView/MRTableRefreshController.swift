//
//  MRTableRefreshController.swift
//  Alamofire
//
//  Created by macode on 2022/1/20.
//

import Foundation
import UIKit
import MJRefresh
import SnapKit

/// 带下拉刷新以及UITableView的 ViewController 基类

/// Usage :
///
/// 1. 创建 Controller
/// let  vc = MRTableRefreshController()
/// 2. 配置 cell 和 identifier
/// vc.register( TextMessageCell.self, "text" )
/// vc.register( ImageMessageCell.self, "image" )
/// 3. 配置数据源
/// vc.dataSetRepo = 这里自定义你的数据源
/// 4. 最后显示当前 Controller 即可

open class MRTableRefreshController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var tableViewStyle: UITableView.Style = .plain
    public var tableView: ZFTableView!
    public var datas:[CellModelProtocol] = [] {
        didSet {
            if self.datas.count == 0 {
                self.showNoDataTipView()
            } else {
//                self.hideNoDataTipView()
            }
        }
    }
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
    
    private var _isHeadRefreshSupported = false
    private var _isFootRefreshSupported = false
    
    /// 是否可以预加载，默认为false
    public var isCanPreload: Bool = false
    public var isRefreshing: Bool = false

    public init(style: UITableView.Style = .plain, hideNavbar: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.tableViewStyle = style
        self.tableView = ZFTableView(frame: .zero, style: style)
            .delegate(self)
            .dataSource(self)
            .backColor(.white)
            .separatorStyle(.none)
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
    
    /// 为特定的cell model 注册对应的 UITableViewCell
    /// - Parameters:
    ///   - cell: cell type
    ///   - identifier: 对应的标识符
    /// - Returns: void
    open func registerCell(_ cell:AnyClass, forCellWithReuseIdentifier identifier: String) -> Void {
        self.tableView?.register(cell, forCellReuseIdentifier: identifier)
    }
    
    
    /// 下拉刷新, 数据添加到列表头部
    /// - Returns: description
    open func pullDownToRefresh() -> Void {
        tableView?.mj_header?.endRefreshing()
        tableView?.mj_footer?.endRefreshing()
//        self.hideNoDataTipView()
        self.dataSetRepo?.fetchData(callback: { [weak self] (newData) in
            self?.onFetchedDataSet(dataSet: newData)
        }) { [weak self] in
            self?.endPullRefresh()
        }
    }
    
    open func onFetchedDataSet(dataSet: [CellModelProtocol]) {
        self.datas = dataSet
        self.reload()
        self.endPullRefresh()
    }
    
    /// 上拉加载更多, 数据追加到列表的尾部
    /// - Returns: description
    open func pullUpToRefresh() -> Void {
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
    
    open func endPullDownRefresh() -> Void {
        tableView.mj_header?.endRefreshing()
        checkNoData()
    }
    
    open func endPullUpRefresh() -> Void {
        tableView.mj_footer?.endRefreshing()
        checkNoData()
    }
    
    open func endPullRefresh() -> Void {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        checkNoData()
    }
    
    open func noticeNoMoreData() -> Void {
        tableView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    open func resetNoMore() -> Void {
        tableView.mj_footer?.resetNoMoreData()
    }
    
    //MARK: - Override
    open func reload() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.datas[indexPath.row].cellHeight()
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataModel = self.datas[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: dataModel.identifier) as? MRTableViewCell {
            cell.selectionStyle = .none
            cell.loadData(dataModel)
            return cell
        }
        return UITableViewCell()
    }
    
    
    /// 获取某行的Cell 对象
    /// - Parameter indexPath: index索引
    /// - Returns: 返回某行的 MRTableViewCell
    func obtainCellForRow(indexPath: IndexPath) -> MRTableViewCell? {
        return self.tableView.cellForRow(at: indexPath) as? MRTableViewCell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        obtainCellForRow(indexPath: indexPath)?.didSelect(nav: self,
                                                                 tableView: tableView, didSelectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return obtainCellForRow(indexPath: indexPath)?.editActions()
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return obtainCellForRow(indexPath: indexPath)?.leadingSwipeActionsConfiguration()
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return obtainCellForRow(indexPath: indexPath)?.trailingSwipeActionsConfiguration()
    }
     
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Override to support conditional editing of the table view.
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    // Override to support editing the table view.
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    open func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    //MARK: - update refresh state
    private func updateHeadRefreshState() -> Void {
        if _isHeadRefreshSupported {
            if self.tableView.mj_header == nil {
                MJRefreshNormalHeader { [weak self] in
                    self?.pullDownToRefresh()
                }.autoChangeTransparency(true)
                    .link(to: tableView)
                if self.autoRefresh {
                    self.tableView?.mj_header?.beginRefreshing()
                }
            }
        } else {
            self.tableView.mj_header?.removeFromSuperview()
        }
    }
    
//    private func tryAutoRefresh() {
//        if self.autoRefresh {
//            DispatchQueue.main.async {
//                self.pullDownToRefresh()
//            }
//        }
//    }
    
    private func updateFootRefreshState() -> Void {
        if _isFootRefreshSupported {
            if self.tableView?.mj_footer == nil {
                MJRefreshAutoFooter { [weak self] in
                    self?.pullUpToRefresh()
                }.autoChangeTransparency(true)
                    .link(to: tableView)
            }
        } else {
            self.tableView?.mj_footer?.removeFromSuperview()
        }
    }
    
    open func checkNoData() {
        if self.datas.count > 0 {
//            self.hideNoDataTipView()
        } else {
            self.showNoDataTipView()
        }
    }
    
    //MARK: - NoDataTip
    open func showNoDataTipView() {
        if  self.datas.count > 0 {
            return
        }
        if self.tableView != nil {
//            NoDataTipView.show(tipView: self.noDataTipView, in: self.tableView!)
//            super.showNoDataTipView()
        }
    }
    
    open func onClickNoDataView() {
        self.tableView.mj_header?.beginRefreshing()
    }
    
    open func preloadData() {
        self.isRefreshing = true
        self.dataSetRepo?.loadMoreData(callback: { [weak self] (newData) in
            guard let self = self else { return }
            self.layoutPreload(newData: newData)
            self.isRefreshing = false
        }) { [weak self] in
            self?.tableView.mj_footer?.state = .idle
            self?.isRefreshing = false
            self?.checkNoData()
        }
    }
    
    open func layoutPreload(newData: [CellModelProtocol]) {
        tableView.mj_footer?.state = .idle
        let indexPaths = newData.enumerated().compactMap({ IndexPath(row: self.datas.count + $0.offset, section: 0) })
        self.datas += newData
        preloadUpdateUI(indexPaths: indexPaths)
        if newData.count == 0 {
            self.noticeNoMoreData()
        }
    }
    
    open func preloadUpdateUI(indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .bottom)
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isCanPreload {
            let height = scrollView.frame.height
            let preloadHeight = scrollView.contentSize.height - scrollView.contentOffset.y
            if preloadHeight >= height, preloadHeight < (height * 3)
                && tableView.mj_footer?.state != .noMoreData, !isRefreshing {
                tableView.mj_footer?.state = .refreshing
                preloadData()
            }
        }
    }
}
