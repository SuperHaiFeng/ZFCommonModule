//
//  UIMaker.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

public func makeButton(_ type: UIButton.ButtonType = .custom) -> ZFButton {
    return ZFButton(buttonType: type)
}

public func makeLabel() -> LLabelMaker {
    return LLabelMaker()
}

public func makeTextField() -> ZFTextField {
    return ZFTextField()
}

public func makeTextView() -> ZFTextView {
    return ZFTextView()
}

public func makeCollecView(_ frame: CGRect = .zero, _ layout: ZFCollectionFlowLayout) -> ZFCollectionView {
    return ZFCollectionView(frame: frame, collectionViewLayout: layout)
}

public func makeFlowLayout() -> ZFCollectionFlowLayout {
    return ZFCollectionFlowLayout()
}

public func makeTableView(_ frame: CGRect, _ style: UITableView.Style) -> ZFTableView {
    return ZFTableView(frame: frame, style: style)
}
