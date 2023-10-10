//
//  UIColor+Ex.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/12.
//

import Foundation

public extension UIColor {
    
    convenience init(hex string: String, alpha: CGFloat = 1) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: alpha)
    }
    
    convenience init(fullHex string: String) {
        let hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        if hex.count == 4, let value = UInt16(hex, radix: 16) {
            self.init(hex4: value)
            return
        }
        if hex.count == 8, let value = UInt32(hex, radix: 16)  {
            self.init(hex8: value)
            return
        }
        self.init(hex: string, alpha: 1)
    }
    
    convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    class func sameColor(_ same:Int, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: CGFloat(Double(same)/255.0), green: CGFloat(Double(same)/255.0), blue: CGFloat(Double(same)/255.0), alpha: alpha)
    }
    
    class func randomColor() -> UIColor {
        return UIColor.init(red: CGFloat(Double((arc4random()%255))/255.0), green: CGFloat(Double((arc4random()%255))/255.0), blue: CGFloat(Double((arc4random()%255))/255.0), alpha: 1)
    }
    
    class func customColor(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    // 计算稍微变浅的颜色 factor越大颜色越浅
    func lighterColor(factor: CGFloat = 0.65) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: min(red + factor, 1.0), green: min(green + factor, 1.0), blue: min(blue + factor, 1.0), alpha: alpha)
    }
}
