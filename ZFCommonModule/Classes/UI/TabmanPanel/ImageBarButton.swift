//
//  ImageBarButton.swift
//  PopVoiceLive
//
//  Created by macode on 2023/2/17.
//  Copyright © 2023 YoYo. All rights reserved.
//

import UIKit
import Tabman

public class ImageBarButton: TMBarButton {
    private let imageView = UIImageView()
    
    public var imageSize: CGSize = CGSize(width: 25, height: 25) {
        didSet {
        }
    }
    
    private var imageItem: ImageBarItem? = nil
        
    public override func populate(for item: TMBarItemable) {
        super.populate(for: item)
        self.imageItem = item as? ImageBarItem
        imageView.image = item.image
    }
    
    public override func layout(in view: UIView) {
        super.layout(in: view)
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.size.equalTo(imageSize)
        }
        
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    public override func update(for selectionState: TMBarButton.SelectionState) {
        imageView.image = selectionState == .selected ? imageItem?.selectedImage : imageItem?.image
    }
}

class ImageBarItem: TMBarItemable {
    var selectedImage: UIImage? {
        didSet {
            setNeedsUpdate()
        }
    }
    
    open var title: String? {
        didSet  {
            setNeedsUpdate()
        }
    }
    open var image: UIImage?  {
        didSet {
            setNeedsUpdate()
        }
    }
    
    open var badgeValue: String? {
        didSet {
            setNeedsUpdate()
        }
    }
    
    convenience init(nor imgName: String, sel selectImage: String) {
        self.init()
        self.image = UIImage(named: imgName)
        self.selectedImage = UIImage(named: selectImage)
    }
}
