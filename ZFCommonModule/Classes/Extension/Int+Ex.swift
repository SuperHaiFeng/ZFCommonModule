//
//  Int+Ex.swift
//  ZFCommonModule
//
//  Created by macode on 2023/10/10.
//


import Foundation

extension Int {
    public var isEven: Bool { return (self % 2 == 0) }
    /// EZSE: Checks if the integer is odd.
    public var isOdd: Bool { return (self % 2 != 0) }
    /// EZSE: Checks if the integer is positive.
    public var isPositive: Bool { return (self > 0) }
    /// EZSE: Checks if the integer is negative.
    public var isNegative: Bool { return (self < 0) }
    /// EZSE: Converts integer value to Double.
    public var toDouble: Double { return Double(self) }
    /// EZSE: Converts integer value to Float.
    public var toFloat: Float { return Float(self) }
    /// EZSE: Converts integer value to CGFloat.
    public var toCGFloat: CGFloat { return CGFloat(self) }
    /// EZSE: Converts integer value to String.
    public var toString: String { return String(self) }
    /// EZSE: Converts integer value to UInt.
    public var toUInt: UInt { return UInt(self) }
    /// EZSE: Converts integer value to a 0..<Int range. Useful in for loops.
    public var range: Range<Int> { return 0 ..< self }
}
