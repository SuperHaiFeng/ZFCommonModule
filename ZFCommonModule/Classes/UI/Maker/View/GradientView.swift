//
//  GradientView.swift
//  Alamofire
//
//  Created by macode on 2022/9/11.
//

import UIKit

public class GradientView: TouchCommonView {
    fileprivate var gradientColors: [CGColor] = []
    fileprivate var gradientDirection: GradientType = .GradientFromLeftToRight
    fileprivate var locations: [CGFloat] = [0.0, 1.0]
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
         
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations) else { return }
        //渐变开始位置
        let start = gradientDirection.startPoint(rect: bounds)
        //渐变结束位置
        let end = gradientDirection.endPoint(rect: bounds)
        
        //绘制渐变
        context.drawLinearGradient(gradient, start: start, end: end,
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }
}

extension GradientView {
    @discardableResult
    public func gradientColor(_ colors: [UIColor], _ direction: GradientType,_ locations: [CGFloat]) -> Self {
        self.gradientColors = colors.compactMap({ $0.cgColor })
        self.gradientDirection = direction
        self.locations = locations
        return self
    }
}
