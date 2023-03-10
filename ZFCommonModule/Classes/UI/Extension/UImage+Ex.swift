//
//  UImage+Ex.swift
//  Alamofire
//
//  Created by macode on 2022/9/5.
//

import UIKit

public enum GradientType {
    case GradientFromTopToBottom
    case GradientFromLeftToRight
    case GradientFromLeftTopToRightBottom
    case GradientFromLeftBottomToRightTop
    
    func startPoint(rect: CGRect) -> CGPoint {
        switch self {
            case .GradientFromLeftToRight:
                return CGPoint(x: rect.minX, y: rect.minY)
            case .GradientFromTopToBottom:
                return CGPoint(x: rect.minX, y: rect.minY)
            case .GradientFromLeftBottomToRightTop:
                return CGPoint(x: rect.minX, y: rect.maxY)
            case .GradientFromLeftTopToRightBottom:
                return CGPoint(x: rect.minX, y: rect.minY)
        }
    }
    
    func endPoint(rect: CGRect) -> CGPoint {
        switch self {
            case .GradientFromLeftToRight:
                return CGPoint(x: rect.maxX, y: rect.minY)
            case .GradientFromTopToBottom:
                return CGPoint(x: rect.minX, y: rect.maxY)
            case .GradientFromLeftBottomToRightTop:
                return CGPoint(x: rect.maxX, y: rect.minY)
            case .GradientFromLeftTopToRightBottom:
                return CGPoint(x: rect.maxX, y: rect.maxY)
        }
    }
}

extension UIImage {
    /// 将图片毛玻璃
    public func blurImage(radius: Int) -> UIImage? {
        guard let cgImage = self.cgImage else { return self }
        let ciImage = CIImage(cgImage: cgImage)
        let filterPara: [String: Any] = [kCIInputImageKey: ciImage, kCIInputRadiusKey: radius]
        let filter = CIFilter(name: "CIGaussianBlur", parameters: filterPara)
        guard let ociImage = filter?.outputImage else { return self }
        let ciContext = CIContext()
        guard let cgimage = ciContext.createCGImage(ociImage, from: ciImage.extent) else { return self }
        let outputImage = UIImage(cgImage: cgimage)
        return outputImage
    }
    
    /// 创建渐变颜色图片
    public class func imageWithSize(size: CGSize, gradientColors: [UIColor], locations: [CGFloat]? = nil, gradientType: GradientType = .GradientFromLeftToRight, radius: CGFloat = 0) -> UIImage? {
        var gradientArray: [CGColor] = []
        let colors = gradientColors
        for color in colors {
            gradientArray.append(color.cgColor)
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        var start: CGPoint?
        var end: CGPoint?
        switch gradientType {
        case .GradientFromTopToBottom:
            start = CGPoint(x: size.width / 2, y: 0)
            end = CGPoint(x: size.width / 2, y: size.height)
        case .GradientFromLeftToRight:
            start = CGPoint(x: 0, y: size.height / 2)
            end = CGPoint(x: size.width, y: size.height / 2)
        case .GradientFromLeftTopToRightBottom:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: size.width, y: size.height)
        case .GradientFromLeftBottomToRightTop:
            start = CGPoint(x: 0, y: size.height)
            end = CGPoint(x: size.width, y: 0)
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientArray as CFArray, locations: locations) else {
            return nil
        }
        context?.drawLinearGradient(gradient, start: start!, end: end!, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if radius > 0 {
            image = image?.imageWithRoundCorner(cornerRadius: radius)
        }
        return image
    }
    
    /// 为图片设置圆角
    public func imageWithRoundCorner(cornerRadius: CGFloat) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        path.addClip()
        draw(in: bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    public func imageWithRoundCorner(_ corners: UIRectCorner, cornerRadii: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        path.addClip()
        draw(in: bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    /// 根据坐标和角度截取图片
    /// - Parameters:
    ///   - rect: 位置
    ///   - angle: 角度
    public func cropImage(withRect rect: CGRect, angle: Double) -> UIImage? {
        // Creates a bitmap-based graphics context with rect size
        // and makes it the current context
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        context.rotate(by: CGFloat(angle / 180 * .pi))
        context.translateBy(x: -rect.width / 2 - rect.minX, y: -rect.height / 2 - rect.minY)
        draw(at: .zero)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}
