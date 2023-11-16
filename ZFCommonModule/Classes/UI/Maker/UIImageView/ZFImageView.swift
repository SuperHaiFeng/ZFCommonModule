//
//  ZFImageView.swift
//  Alamofire
//
//  Created by macode on 2023/10/11.
//

import UIKit

open class ZFImageView: UIImageView, TouchZoomAnimationProtocol, TouchColorProtocol {
    public var touchAnimation: TouchColorAnimation?
    
    public var touchColorItem: TouchColorItem?
    public var touchZoomItem: TouchZoomAnimationItem?
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        zoomTouchesBegan(touches, with: event)
        if event?.allTouches?.count ?? 0 == 1 {
            colorTouchesBegan(touches, with: event)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        zoomTouchesEnded(touches, with: event)
        colorTouchesEnded(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        zoomTouchesCancelled(touches, with: event)
        colorTouchesCancelled(touches, with: event)
    }
}
