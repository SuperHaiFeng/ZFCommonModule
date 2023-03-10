//
//  AwesomeCollectionViewCell.swift
//  Alamofire
//
//  Created by macode on 2022/1/20.
//

import UIKit

/// Model 为 CellModelProtocol 抽象的UICollectionViewCell实现类, 子类在 loadData 函数中对数据进行一次类型转换即可
open class MRCollectionViewCell: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func loadSubviews() {
        
    }
    
    /// 将数据绑定到cell 中
    /// - Parameter model: 要绑定的数据模型
    /// - Returns: description
    open func loadData(_ model: CellModelProtocol) -> Void {
        
    }
    
    open func didSelect(nav: UINavigationController?, collectionView: UICollectionView, didSelectRowAt indexPath: IndexPath) -> Void {
        
    }
}

/// 自动进行类型转换的  MRCollectionViewCell
open class AwesomeCollectionViewCell<T> : MRCollectionViewCell where T : CellModelProtocol {
    /// 类型确定的 Model
    public var curModel: T?
    
    open override func loadSubviews() {
        
    }
    
    open override func loadData(_ model: CellModelProtocol) {
        super.loadData(model)
        if let modelItem = model as? T {
            self.curModel = modelItem
            onBindData(model: modelItem)
        }
    }
    
    /// 绑定数据到 UI上
    /// - Parameter model: model description
    open func onBindData(model: T) {
        
    }
}

/// 点击缩小动画
//MARK: 在使用时，点击cell事件会有个延迟触发touchBegin，如果想要点击就触发touchBegin，需要设置collectionView.delaysContentTouches = false
//MARK: 取消延迟执行执行touchBegin，可能会对其他手势有影响，请选择使用
open class TouchAnimationCollectionCell<T>: AwesomeCollectionViewCell<T>, TouchZoomAnimationProtocol, TouchColorProtocol where T: CellModelProtocol {
    public var touchAnimation: TouchColorAnimation?
    
    public var touchColorItem: TouchColorItem?
    
    public var touchZoomItem: TouchZoomAnimationItem?
    
    open override func loadSubviews() {
        
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        zoomTouchesBegan(touches, with: event)
        colorTouchesBegan(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        zoomTouchesEnded(touches, with: event)
        colorTouchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        zoomTouchesCancelled(touches, with: event)
        colorTouchesCancelled(touches, with: event)
    }
    
}
