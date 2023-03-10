//
//  DialogAirBubbleSelector.swift
//  ZFCommonModule
//
//  Created by macode on 2022/9/16.
//

import UIKit

/// 气泡选择项，需要创建传入AirBubbleSelector中
public struct BubbleItem {
    // 气泡显示的内容
    public var title: String
    // 点击气泡回调事件
    public var handle: CommonCallback<Bool>
    
    public init(title: String, handle: @escaping CommonCallback<Bool>) {
        self.title = title
        self.handle = handle
    }
}

/// 气泡选择器
public class AirBubbleSelector: UIView, DialogContentDisappear {
    public var disappear: Delegate<Bool, Void> = Delegate<Bool, Void>()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.alignment = .leading
        return stack
    }()

    public convenience init(items: [BubbleItem]) {
        self.init()
        loadSubviews(items: items)
    }

    private func loadSubviews(items: [BubbleItem]) {
        self.backColor(.white).corner(4).addShadow(color: .black, offset: CGSize(width: 1, height: 1))
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        items.forEach { item in
            let itemLabel = makeLabel().text(item.title)
                .font(.boldSystemFont(ofSize: 16))
                .paddingEdge(UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)).maker()
                .touchColor(TouchColorItem(), TouchLommingAnimtionImpl())
            stackView.addArrangedSubview(itemLabel)
            itemLabel.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(120)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            _ = itemLabel.rx.click.subscribe { [weak self] _ in
                guard let self = self else { return }
                item.handle(true)
                self.disappear.call(true)
            }
        }
    }
    
    deinit {
        print("deinit AireButtleSelector")
    }

}
