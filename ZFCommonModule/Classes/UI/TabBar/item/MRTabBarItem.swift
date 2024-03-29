//
//  MRTabBarItem.swift
//  PopVoiceLive
//
//  Created by 董帅军 on 2020/3/30.
//  Copyright © 2020 Talla. All rights reserved.
//

import UIKit

/*
 * ESTabBarItem继承自UITabBarItem，目的是为ESTabBarItemContentView提供UITabBarItem属性的设置。
 * 目前支持大多常用的属性，例如image, selectedImage, title, tag 等。
 *
 * Unsupport properties:
 *  MARK: UIBarItem properties
 *      1. var isEnabled: Bool
 *      2. var landscapeImagePhone: UIImage?
 *      3. var imageInsets: UIEdgeInsets
 *      4.  var landscapeImagePhoneInsets: UIEdgeInsets
 *      5. func setTitleTextAttributes(_ attributes: [String : Any]?, for state: UIControlState)
 *      6. func titleTextAttributes(for state: UIControlState) -> [String : Any]?
 *  MARK: UITabBarItem properties
 *      7. var titlePositionAdjustment: UIOffset
 *      8. func setBadgeTextAttributes(_ textAttributes: [String : Any]?, for state: UIControlState)
 *      9. func badgeTextAttributes(for state: UIControlState) -> [String : Any]?
 */
@available(iOS 8.0, *)
open class MRTabBarItem: UITabBarItem {
    /// Customize content view
    open var contentView: MRTabBarItemContentView?

    // MARK: UIBarItem properties

    open override var title: String? { // default is nil
        didSet { self.contentView?.title = title }
    }

    open override var image: UIImage? { // default is nil
        didSet { self.contentView?.image = image }
    }

    // MARK: UITabBarItem properties

    open override var selectedImage: UIImage? { // default is nil
        didSet { self.contentView?.selectedImage = selectedImage }
    }

    open var norTextColor: UIColor? { // default is nil
        didSet { self.contentView?.textColor = norTextColor ?? .black }
    }

    // MARK: UITabBarItem properties

    open var selTextColor: UIColor? { // default is nil
        didSet { self.contentView?.highlightTextColor = selTextColor ?? .black }
    }

    open override var badgeValue: String? { // default is nil
        get { return contentView?.badgeValue }
        set(newValue) { contentView?.badgeValue = newValue }
    }

    open var renderingMode: UIImage.RenderingMode = .alwaysTemplate { // default is nil
        didSet { contentView?.renderingMode = renderingMode }
    }

    /// Override UITabBarItem.badgeColor, make it available for iOS8.0 and later.
    /// If this item displays a badge, this color will be used for the badge's background. If set to nil, the default background color will be used instead.
    @available(iOS 8.0, *)
    open override var badgeColor: UIColor? {
        get { return contentView?.badgeColor }
        set(newValue) { contentView?.badgeColor = newValue }
    }

    open override var tag: Int { // default is 0
        didSet { contentView?.tag = tag }
    }

    /* The unselected image is autogenerated from the image argument. The selected image
     is autogenerated from the selectedImage if provided and the image argument otherwise.
     To prevent system coloring, provide images with UIImageRenderingModeAlwaysOriginal (see UIImage.h)
     */
    public init(_ contentView: MRTabBarItemContentView = MRTabBarItemContentView(), renderingMode: UIImage.RenderingMode? = nil, title: String? = nil, norTextColor: UIColor? = nil, selTextColor: UIColor? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, tag: Int = 0) {
        super.init()
        self.contentView = contentView
        setTitle(renderingMode, title: title, norTextColor: norTextColor, selTextColor: selTextColor, image: image, selectedImage: selectedImage, tag: tag)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setTitle(_ renderingMode: UIImage.RenderingMode? = nil, title: String? = nil, norTextColor: UIColor? = nil, selTextColor: UIColor? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, tag: Int = 0) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.tag = tag
        self.norTextColor = norTextColor
        self.selTextColor = selTextColor
        self.renderingMode = renderingMode ?? .alwaysTemplate
    }
}
