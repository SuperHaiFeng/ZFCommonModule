//
//  CAGradientLayer+EX.swift
//  ZFCommonModule
//
//  Created by macode on 2023/9/27.
//

public enum GradientDirection {
    case GradientLeftToRight
    case GradientTopToBottom
    case GradientTopLeftToRightBottom
    case GradientTopRightToLeftBottom
}

extension CAGradientLayer {
    public class func gradientLayer(colors: [UIColor], direction: GradientDirection) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.compactMap({ $0.cgColor })
      
        let points = CAGradientLayer.transformPoints(direction: direction)
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end
        return gradientLayer
    }
    
    private class func transformPoints(direction: GradientDirection) -> (start: CGPoint, end: CGPoint) {
        var startPoint = CGPoint(x: 0, y: 0)
        var endPoint = CGPoint(x: 0, y: 0)
        switch direction {
        case .GradientLeftToRight:
            startPoint = CGPoint(x: 0, y: 0.5)
            endPoint = CGPoint(x: 1, y: 0.5)
        case .GradientTopToBottom:
            startPoint = CGPoint(x: 0.5, y: 0)
            endPoint = CGPoint(x: 0.5, y: 1)
        case .GradientTopLeftToRightBottom:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 1)
        case .GradientTopRightToLeftBottom:
            startPoint = CGPoint(x: 1, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        }
        return (startPoint, endPoint)
    }
}


