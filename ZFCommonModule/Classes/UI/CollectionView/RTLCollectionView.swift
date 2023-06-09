//
//  RTLCollectionView.swift
//  ZFCommonModule
//
//  Created by macode on 2022/1/20.
//

import UIKit

open class RTLCollectionView: UICollectionView {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
//        if CommonMethods.isRTLLayout() {
//            self.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//        }
    }
}

public class SemanticContentFlowLayout: UICollectionViewFlowLayout {
//    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
//        return CommonMethods.isRTLLayout() ? .rightToLeft : .leftToRight
//    }
    
    public override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
}
