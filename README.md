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

## Author

Yalda, zhangzhifang1013@gmail.com

## License

ZFCommonModule is available under the MIT license. See the LICENSE file for more info.
