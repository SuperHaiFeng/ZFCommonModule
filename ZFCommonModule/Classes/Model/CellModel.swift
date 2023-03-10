//
//  CellModel.swift
//  Alamofire
//
//  Created by macode on 2022/1/20.
//


/// Cell Model Protocol, 所有需要添加到 MRTableRefreshController 、MRCollectionRefreshController 中的数据类型都需要实现这个协议
public protocol CellModelProtocol {
    var identifier: String { get set }
    
    func cellHeight() -> CGFloat
}

/// 用于 UITableViewCell 的 模型基类
open class CellModel : NSObject, CellModelProtocol {
    
    public static let DEFAULT_IDENTIFIER = "default_cell_identifier"
    
    /// cell 对应的标识符
    public var identifier: String = CellModel.DEFAULT_IDENTIFIER
    
    /// cell 所需的高度
    /// - Returns: 根据model 的具体情况计算
    open func cellHeight() -> CGFloat {
        return 60
    }
}
