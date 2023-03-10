//
//  TableViewDataRepository.swift
//  Alamofire
//
//  Created by macode on 2022/1/20.
//

/// Table View 的数据仓库, 为列表提供下拉刷新、加载更多的数据
public protocol TableViewDataRepository {
    
    /// 下拉刷新时获取数据
    /// - Parameters:
    ///   - callback: 请求成功的回调
    ///   - failure: 请求失败的回调
    func fetchData(callback: @escaping ([CellModelProtocol]) -> Void, failure: @escaping () -> Void)
    
    /// 上拉加载更多时的加载数据
    /// - Parameters:
    ///   - callback: 请求成功的回调
    ///   - failure: 请求失败的回调
    func loadMoreData(callback: @escaping ([CellModelProtocol]) -> Void, failure: @escaping () -> Void)
}
