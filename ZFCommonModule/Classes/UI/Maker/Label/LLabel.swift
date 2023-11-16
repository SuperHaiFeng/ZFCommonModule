//
//  LLabel.swift
//  Alamofire
//
//  Created by macode on 2022/9/2.
//

import UIKit

public enum FontWeight {
    case Regular
    case UltraLight
    case Thin
    case Light
    case Medium
    case Semibold
    case Bold
    case Heavy
    case Black
}

@available(iOS 8.2, *)
func getFontWeight(_ weight: FontWeight) -> UIFont.Weight {
    switch weight {
    case .Regular:
        return .regular
    case .UltraLight:
        return .ultraLight
    case .Thin:
        return .thin
    case .Light:
        return .light
    case .Medium:
        return .medium
    case .Semibold:
        return .semibold
    case .Bold:
        return .bold
    case .Heavy:
        return .heavy
    case .Black:
        return .heavy
    }
}

open class LLabel: UILabel, TouchZoomAnimationProtocol, TouchColorProtocol, UIViewModifyTriggerProtocol {
    public var touchAnimation: TouchColorAnimation?
    
    // 设置边距
    open var paddingEdge = UIEdgeInsets()
    fileprivate var imgColors: [UIColor] = []
    fileprivate var gradientColors: [CGColor] = []
    fileprivate var gradientDirection: GradientType = .GradientFromLeftToRight
    
    fileprivate var locations: [CGFloat]? = nil
    /// 渐变颜色动画
    fileprivate var animationColors: [CGColor] = []
    private var link : CADisplayLink? = nil
    
    /// 点击选择背景颜色
    public var touchColorItem: TouchColorItem?
        
    /// 扩大点击范围
    public var areaEdge: UIEdgeInsets = .zero
    
    /// 是否需要zoom动画
    public var touchZoomItem: TouchZoomAnimationItem?

    public init(_ text: String = "", _ textColor: UIColor = UIColor.black, _ fontSize: CGFloat = 13, _ alignment: NSTextAlignment = .left, _ fontWeight: FontWeight = FontWeight.Regular) {
        super.init(frame: CGRect())
        self.text = text
        self.textColor = textColor
        if #available(iOS 8.2, *) {
            self.font = UIFont.systemFont(ofSize: fontSize, weight: getFontWeight(fontWeight))
        } else {
            font = UIFont.systemFont(ofSize: fontSize)
        }

        textAlignment = alignment
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open var paddingLeft: CGFloat {
        get { return paddingEdge.left }
        set { paddingEdge.left = newValue }
    }

    open var paddingRight: CGFloat {
        get { return paddingEdge.right }
        set { paddingEdge.right = newValue }
    }

    open var paddingTop: CGFloat {
        get { return paddingEdge.top }
        set { paddingEdge.top = newValue }
    }

    open var paddingBottom: CGFloat {
        get { return paddingEdge.bottom }
        set { paddingEdge.bottom = newValue }
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: paddingEdge))
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = paddingEdge
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return pointInArea(inside: point, with: event)
    }

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
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if gradientColors.count > 1 {
            drawGradientText(rect: rect)
        }
        if animationColors.count > 1 {
            drawGradientAnimation(rect: rect)
        }
    }
    
    /// 绘制渐变字体颜色
    private func drawGradientText(rect: CGRect) {
        let colorSpace : CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations)
        let startPoint = gradientDirection.startPoint(rect: rect)
        let endPoint = gradientDirection.endPoint(rect: rect)
        
        drawBaseGradientText(rect: rect, gradient: gradient, start: startPoint, end: endPoint)
    }
    
    /// 绘制渐变字体颜色动画
    private func drawGradientAnimation(rect: CGRect) {
        struct ConsoleBox {
            static var adding : CGFloat = 0
            static var add : Bool = true
        }
        
        let colorSpace : CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: animationColors as CFArray, locations: locations)
        var startPoint = CGPoint.init(x: -rect.size.width, y: 0)
        var endPoint = CGPoint.init(x: 0, y: rect.size.height)
        
        if ConsoleBox.adding > rect.size.width * 2 {
            ConsoleBox.add = true
            ConsoleBox.adding = 0
        }else if ConsoleBox.adding <= 0 {
            ConsoleBox.add = true
        }
        if ConsoleBox.add {
            ConsoleBox.adding += rect.size.width / 150
        }else{
            ConsoleBox.adding -= rect.self.width / 150
        }
        startPoint = CGPoint.init(x: startPoint.x + ConsoleBox.adding, y: startPoint.y)
        endPoint = CGPoint.init(x: endPoint.x + ConsoleBox.adding, y: endPoint.y)
        drawBaseGradientText(rect: rect, gradient: gradient, start: startPoint, end: endPoint)
        
        startTextGradient()
    }
    
    private func drawBaseGradientText(rect: CGRect, gradient: CGGradient?, start: CGPoint, end: CGPoint) {
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0.0, y: rect.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        let alphaMsk : CGImage? = context?.makeImage()
        context?.clear(rect)
        context?.clip(to: rect, mask: alphaMsk!)
        
        if let gradient = gradient {
            context?.drawLinearGradient(gradient, start: start, end: end, options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
        }
    }
    
    /// 开始执行渐变颜色动画
    public func startTextGradient() {
        link = CADisplayLink.init(target: self, selector: #selector(changeState))
        if #available(iOS 10.0, *) {
            link?.preferredFramesPerSecond = 60;
        }else{
            link?.frameInterval = 1
        }
        link?.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc private func changeState() {
        self.setNeedsDisplay()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if imgColors.count > 0 {
            guard let gradientImg = UIImage.imageWithSize(size: frame.size, gradientColors: imgColors) else {
                return
            }
            self.textColor = UIColor(patternImage: gradientImg)
        }
    }
}

extension LLabel {
    @discardableResult
    public func gradientColorWithImg(_ colors: [UIColor]) -> Self {
        self.imgColors = colors
        return self
    }
    
    /// 使用渐变字体颜色时，背景颜色不要设置，不然不生效
    @discardableResult
    public func gradientColor(_ colors: [UIColor], _ direction: GradientType, _ locations: [CGFloat]? = nil) -> Self {
        self.gradientColors = colors.compactMap({ $0.cgColor })
        self.gradientDirection = direction
        self.locations = locations
        return self
    }
    
    /// 设置渐变颜色自己动画，从左往右移动，animationColors中第一个和最后一个颜色为字体默认颜色
    /// 不能和渐变颜色gradientColor同时设置
    @discardableResult
    public func gradientAnimatoin(_ animationColors: [UIColor], _ locations: [CGFloat]? = nil) -> Self {
        self.animationColors = animationColors.compactMap({ $0.cgColor })
        self.locations = locations
        return self
    }
    
    @discardableResult
    public func numberLines(_ number: Int) -> Self {
        self.numberOfLines = number
        return self
    }
    
    /// 点击区域设置大小
    /// 扩大点击区域，对应数值为负数，反之为正数
    @discardableResult
    public func touchAreaEdge(_ edge: UIEdgeInsets) -> Self {
        self.areaEdge = edge
        return self
    }
    
    @discardableResult
    public func isUserInteractionEnabled(_ enable: Bool) -> Self {
        self.isUserInteractionEnabled = enable
        return self
    }
    
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjusts
        return self
    }
    
    @discardableResult
    public func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.lineBreakMode = mode
        return self
    }
    
    @discardableResult
    public func shadowColor(shadowColor: UIColor) -> Self {
        self.shadowColor = shadowColor
        return self
    }
    
    @discardableResult
    public func shadowOffset(shadowOffset: CGSize) -> Self {
        self.shadowOffset = shadowOffset
        return self
    }
}

