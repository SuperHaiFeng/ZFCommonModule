//
//  DialogSheetPanel.swift
//  Alamofire
//
//  Created by macode on 2023/3/9.
//

import UIKit

open class DialogSheetPanel: UIView, DialogContentDisappear {
    public var disappear: Delegate<Bool, Void> = Delegate<Bool, Void>()
    
    private let arrow = UIImageView(image: UIImage(named: "minus_48pt"))
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 350))
        loadSubviews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    open func loadSubviews() {
        backgroundColor = .white
        addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.size.equalTo(28)
        }
    }
    
    public func viewWillDisappear(disappear: Bool) {
        arrow.image = UIImage(named: disappear ? "angle-small-down_48pt" : "minus_48pt")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
