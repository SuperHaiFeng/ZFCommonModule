# ZFCommonModule

[![CI Status](https://img.shields.io/travis/Macoming/ZFCommonModule.svg?style=flat)](https://travis-ci.org/Macoming/ZFCommonModule)
[![Version](https://img.shields.io/cocoapods/v/ZFCommonModule.svg?style=flat)](https://cocoapods.org/pods/ZFCommonModule)
[![License](https://img.shields.io/cocoapods/l/ZFCommonModule.svg?style=flat)](https://cocoapods.org/pods/ZFCommonModule)
[![Platform](https://img.shields.io/cocoapods/p/ZFCommonModule.svg?style=flat)](https://cocoapods.org/pods/ZFCommonModule)

## Example

#### UI的函数式创建

##### 包括（UIView，UIView，UITableView, UICollectionView, UILabel, UITextFiled, UITextView...）

##### 对UIView扩展了一个点击显示背景颜色的协议TouchSelectProtocol 和 点击缩小动画的协议TouchZoomAnimationProtocol

##### 只要继承自UIView的空间，只要实现这两个协议都可以实现动画

##### UIVIew还扩展了一个扩大事件触发区域的协议UIViewModifyTriggerProtocol，实现这个协议，并且在pointIn方法中调用方法就可以扩大触发区域，目前对所有继承自UIView的类都可以使用

## Installation

ZFCommonModule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZFCommonModule'
```
要实现渐变颜色的字体，并需要点击事件渐变颜色和那边距设置，只需要这么实现：
```swift
let titleLabel = makeLabel().text("This is title This is title This is title")
        .font(.boldSystemFont(ofSize: 25))
        .paddingEdge(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        .corner(4)
        .alignment(.center)
        .textColor(.cyan).maker()
        .gradientColor([.cyan, .red, .green], .GradientFromLeftToRight, [0.2, 0.3, 0.8])
        .gradientAnimatoin([.cyan, .yellow, .red, .blue, .green, .brown, .cyan])
        .zoomAnimation(ZoomAnimationItem(0.6))
        .touchColor(TouchColorItem(), TouchLommingAnimtionImpl())
        .isUserInteractionEnabled(true)
        .numberLines(0)
```

按钮的创建以及设置点击区域：
```swift
let button = makeButton(.custom).title("Create").corner(8).font(.boldSystemFont(ofSize: 18)).titleColor(.red)
        .image(UIImage(named: "btn_submit_nor"))
        .imageEdge(.top, 8)
        .touchAreaEdge(UIEdgeInsets(top: -40, left: -40, bottom: -40, right: -40))
        .backColor(.lightGray)
        .borderColor(.black)
        .borderWidth(2)
        .bgImage(UIImage.imageWithSize(size: CGSize(width: 2, height: 2), gradientColors: [.link, .cyan]), .normal)
        .touchZoomItem(TouchZoomAnimationItem())
        .touchColor(TouchColorItem(), TouchLommingAnimtionImpl())
        .exclusiveTouch(true)
```

如果想要创建一个渐变背景色的view：
```swift
let gradientView = GradientView().gradientColor([.link, .cyan], .GradientFromLeftToRight,  [0.0, 1.0])
        .corner(12)
        .borderColor(.black)
        .borderWidth(2)
        .touchZoomItem(TouchZoomAnimationItem(0.6, scale: 0.9, end: 0.1))
        .exclusiveTouch(true)
```

创建常见的弹框，比如中间弹框，侧边栏等动画：
```swift
// 这个是实现气泡弹框，例如qq弹框，显示在某个锚点的下方
  let black = BubbleItem(title: "打开图像滤镜器", handle: { [weak self] _ in
    self?.navigationController?.pushViewController(FilterImageController(), animated: true)
  })
  let report = BubbleItem(title: "Report", handle: { _ in
      
  })
  let creat = BubbleItem(title: "创建群聊创建群聊", handle: { _ in
      
  })
  let scan = BubbleItem(title: "扫一扫", handle: { _ in
      
  })
  
  let contentView = AirBubbleSelector(items: [black, report, creat, scan])
  let params = DialogParams(contentAnimation: DropDownLommingAnimation(), contentView: contentView)
  DialogBackView(params: params, anchor: titleLabel).panDismiss(enabled: true, panPosition: .bottom).showInWindow()

  /// 这个是实现从下往上弹框，contentAnimation传动画对象 contentView为弹框内容
  let params = DialogParams(contentAnimation: BottomMoveUpAnimation(), contentView: DialogSheetPanel())
  DialogBackView(params: params).panDismiss(enabled: true, panPosition: .bottom).showInWindow()
```


## Author

Yalda, zhangzhifang1013@gmail.com

## License

ZFCommonModule is available under the MIT license. See the LICENSE file for more info.
