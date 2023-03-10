//
//  ZFTableView.swift
//  Alamofire
//
//  Created by macode on 2022/9/9.
//

import UIKit

public class ZFTableView: UITableView {


}

extension ZFTableView {
    
    @discardableResult
    public func register(cells: [String: AnyClass]) -> Self {
        cells.forEach({ register($0.value, forCellReuseIdentifier: $0.key) })
        return self
    }
    
    @discardableResult
    public func register(views: [String: AnyClass]) -> Self {
        views.forEach({ register($0.value, forHeaderFooterViewReuseIdentifier: $0.key) })
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    @discardableResult
    public func prefetchDataSource(_ dataSource: UITableViewDataSourcePrefetching) -> Self {
        self.prefetchDataSource = dataSource
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func isPrefetchingEnabled(_ enable: Bool) -> Self {
        self.isPrefetchingEnabled = enable
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragDelegate(_ delegate: UITableViewDragDelegate) -> Self {
        self.dragDelegate = delegate
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dropDelegate(_ delegate: UITableViewDropDelegate) -> Self {
        self.dropDelegate = delegate
        return self
    }
    
    @discardableResult
    public func rowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }
    
    @discardableResult
    public func sectionHeaderHeight(_ height: CGFloat) -> Self {
        self.sectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    public func sectionFooterHeight(_ height: CGFloat) -> Self {
        self.sectionFooterHeight = height
        return self
    }
    
    @discardableResult
    public func estimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }
    
    @discardableResult
    public func estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    public func estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = height
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func fillerRowHeight(_ height: CGFloat) -> Self {
        self.fillerRowHeight = height
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func sectionHeaderTopPadding(_ height: CGFloat) -> Self {
        self.sectionHeaderTopPadding = height
        return self
    }
    
    @discardableResult
    public func separatorInset(_ inset: UIEdgeInsets) -> Self {
        self.separatorInset = inset
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func separatorInsetReference(_ inset: UITableView.SeparatorInsetReference) -> Self {
        self.separatorInsetReference = inset
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
    public func allowsSelectionDuringEditing(_ editing: Bool) -> Self {
        self.allowsSelectionDuringEditing = editing
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ editing: Bool) -> Self {
        self.allowsMultipleSelectionDuringEditing = editing
        return self
    }
    
    @discardableResult
    public func sectionIndexMinimumDisplayRowCount(_ rowCount: Int) -> Self {
        self.sectionIndexMinimumDisplayRowCount = rowCount
        return self
    }
    
    @discardableResult
    public func sectionIndexColor(_ color: UIColor) -> Self {
        self.sectionIndexColor = color
        return self
    }
    
    @discardableResult
    public func sectionIndexBackgroundColor(_ color: UIColor) -> Self {
        self.sectionIndexBackgroundColor = color
        return self
    }
    
    @discardableResult
    public func sectionIndexTrackingBackgroundColor(_ color: UIColor) -> Self {
        self.sectionIndexTrackingBackgroundColor = color
        return self
    }
    
    @discardableResult
    public func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    
    @discardableResult
    public func separatorColor(_ color: UIColor) -> Self {
        self.separatorColor = color
        return self
    }
    
    @discardableResult
    public func separatorEffect(_ effect: UIVisualEffect) -> Self {
        self.separatorEffect = effect
        return self
    }
    
    @discardableResult
    public func cellLayoutMarginsFollowReadableWidth(_ readable: Bool) -> Self {
        self.cellLayoutMarginsFollowReadableWidth = readable
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func insetsContentViewsToSafeArea(_ readable: Bool) -> Self {
        self.insetsContentViewsToSafeArea = readable
        return self
    }
    
    @discardableResult
    public func tableHeaderView(_ view: UIView) -> Self {
        self.tableHeaderView = view
        return self
    }
    
    @discardableResult
    public func tableFooterView(_ view: UIView) -> Self {
        self.tableFooterView = view
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
    
    @discardableResult
    public func remembersLastFocusedIndexPath(_ focused: Bool) -> Self {
        self.remembersLastFocusedIndexPath = focused
        return self
    }
    
    /// touches事件是否延迟执行，默认为true
    @discardableResult
    public func delaysContentTouches(_ delay: Bool) -> Self {
        self.delaysContentTouches = delay
        return self
    }
    
}

