//
//  ZFCollectionView.swift
//  Alamofire
//
//  Created by macode on 2022/9/9.
//

import UIKit

public class ZFCollectionView: RTLCollectionView {
    
}

public class ZFCollectionFlowLayout: SemanticContentFlowLayout {
    
}

extension ZFCollectionView {
    @discardableResult
    public func delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    @discardableResult
    public func prefetchDataSource(_ dataSource: UICollectionViewDataSourcePrefetching) -> Self {
        self.prefetchDataSource = dataSource
        return self
    }
    
    @discardableResult
    public func isPrefetchingEnabled(_ enable: Bool) -> Self {
        self.isPrefetchingEnabled = enable
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragDelegate(_ delegate: UICollectionViewDragDelegate) -> Self {
        self.dragDelegate = delegate
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dropDelegate(_ delegate: UICollectionViewDropDelegate) -> Self {
        self.dropDelegate = delegate
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragInteractionEnabled(_ enable: Bool) -> Self {
        self.dragInteractionEnabled = enable
        return self
    }
    
    @discardableResult
    public func pageEnable(_ pageEnable: Bool) -> Self {
        self.isPagingEnabled = pageEnable
        return self
    }
    
    @discardableResult
    public func showHorizontal(_ isShow: Bool) -> Self {
        self.showsHorizontalScrollIndicator = isShow
        return self
    }
    
    @discardableResult
    public func showVertical(_ isShow: Bool) -> Self {
        self.showsVerticalScrollIndicator = isShow
        return self
    }
    
    @discardableResult
    public func bounces(_ bounce: Bool) -> Self {
        self.bounces = bounce
        return self
    }
    
    @discardableResult
    public func register(_ cells: [String: AnyClass]) -> Self {
        cells.forEach({ register($0.value, forCellWithReuseIdentifier: $0.key) })
        return self
    }
    
    @discardableResult
    public func register(_ views: [String: AnyClass], _ viewOfKind: String) -> Self {
        views.forEach({ register($0.value, forSupplementaryViewOfKind: viewOfKind, withReuseIdentifier: $0.key) })
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func reorderingCadence(_ cadence: UICollectionView.ReorderingCadence) -> Self {
        self.reorderingCadence = cadence
        return self
    }
    
    @discardableResult
    public func backgroundView(_ view: UIView) -> Self {
        self.backgroundView = view
        return self
    }
    
    /// 默认 true
    @discardableResult
    public func allowsSelection(_ allow: Bool) -> Self {
        self.allowsSelection = allow
        return self
    }
    
    /// 默认false
    @discardableResult
    public func allowsMultipleSelection(_ allow: Bool) -> Self {
        self.allowsMultipleSelection = allow
        return self
    }
    
    @discardableResult
    public func remembersLastFocusedIndexPath(_ focused: Bool) -> Self {
        self.remembersLastFocusedIndexPath = focused
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func selectionFollowsFocus(_ focus: Bool) -> Self {
        self.selectionFollowsFocus = focus
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func allowsFocus(_ focus: Bool) -> Self {
        self.allowsFocus = focus
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func allowsFocusDuringEditing(_ editing: Bool) -> Self {
        self.allowsFocusDuringEditing = editing
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func isEditing(_ isEditing: Bool) -> Self {
        self.isEditing = isEditing
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func allowsSelectionDuringEditing(_ editing: Bool) -> Self {
        self.allowsSelectionDuringEditing = editing
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ editing: Bool) -> Self {
        self.allowsMultipleSelectionDuringEditing = editing
        return self
    }
    
    /// touches事件是否延迟执行，默认为true
    @discardableResult
    public func delaysContentTouches(_ delay: Bool) -> Self {
        self.delaysContentTouches = delay
        return self
    }
}

extension ZFCollectionFlowLayout {
    @discardableResult
    public func size(_ size: CGSize) -> Self {
        self.itemSize = size
        return self
    }
    
    @discardableResult
    public func lineSpacing(_ spacing: CGFloat) -> Self {
        self.minimumLineSpacing = spacing
        return self
    }
    
    @discardableResult
    public func interSpacing(_ spacing: CGFloat) -> Self {
        self.minimumInteritemSpacing = spacing
        return self
    }
    
    @discardableResult
    public func direction(_ direction: UICollectionView.ScrollDirection) -> Self {
        self.scrollDirection = direction
        return self
    }
    
    @discardableResult
    public func headerReferenceSize(_ size: CGSize) -> Self {
        self.headerReferenceSize = size
        return self
    }
    
    @discardableResult
    public func footerReferenceSize(_ size: CGSize) -> Self {
        self.footerReferenceSize = size
        return self
    }
    
    @discardableResult
    public func sectionInset(_ inset: UIEdgeInsets) -> Self {
        self.sectionInset = inset
        return self
    }
    
    @discardableResult
    public func sectionHeadersPinToVisibleBounds(_ bounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = bounds
        return self
    }
    
    @discardableResult
    public func sectionFootersPinToVisibleBounds(_ bounds: Bool) -> Self {
        self.sectionFootersPinToVisibleBounds = bounds
        return self
    }
    
}
