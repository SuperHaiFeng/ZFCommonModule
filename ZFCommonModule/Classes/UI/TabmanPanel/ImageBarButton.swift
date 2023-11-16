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
    public lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 3
        stack.alignment = .center
        return stack
    }()
    private let imageView = UIImageView()
    private let titleLabel = makeLabel().font(.systemFont(ofSize: 16, weight: .medium)).textColor(.black).maker()
    
    public var imageSize: CGSize = CGSize(width: 25, height: 25) {
        didSet {
        }
    }
    
    private var imageItem: ImageBarItem? = nil
        
    public override func populate(for item: TMBarItemable) {
        super.populate(for: item)
        self.imageItem = item as? ImageBarItem
        imageView.image = item.image
        self.titleLabel.text = item.title
        self.imageView.isHidden = item.image == nil
        self.titleLabel.isHidden = item.title == nil
    }
    
    public override func layout(in view: UIView) {
        super.layout(in: view)
        view.addSubview(stackView) { make in
            make.center.equalToSuperview()
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
        }
        
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    public override func update(for selectionState: TMBarButton.SelectionState) {
        imageView.image = selectionState == .selected ? imageItem?.selectedImage : imageItem?.image
        titleLabel.textColor = selectionState == .selected ? imageItem?.titleSelectColor : imageItem?.titleColor
    }
}

public class ImageBarItem: TMBarItemable {
    public var selectedImage: UIImage? {
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
    
    open var titleColor: UIColor = .black {
        didSet {
            setNeedsUpdate()
        }
    }
    
    open var titleSelectColor: UIColor = .systemPink {
        didSet {
            setNeedsUpdate()
        }
    }
    
    public convenience init(nor imgName: String, sel selectImage: String) {
        self.init()
        self.image = UIImage(named: imgName)
        self.selectedImage = UIImage(named: selectImage)
    }
    
    public convenience init(title: String, color: UIColor, sel: UIColor) {
        self.init()
        self.title = title
        self.titleColor = color
        self.titleSelectColor = sel
    }
}
