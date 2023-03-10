//
//  StrategyDecision.swift
//  ZFDBModule
//
//  Created by macode on 2022/1/20.
//

import Foundation

/// 用于改造 拆分 if- else 或 switch 的通用策略模式
/// T 为 输入参数， R为返回值
/// Mutation为执行的同步任务
/// Action 为执行的异步任务
/// 根据协议实现了一个 基于 class 的通用版本， 也可以使用 struct 实现，但扩展性不太方便
/// Abstract开头的类需要继承使用
/// Common 开头的类可以直接使用， 根据情况使用继承


/// 决策者 commit 调用同步方法，dispatch调用异步方法
public protocol StrategyDecision {
    associatedtype T where T: StrategyHandlerMapperKeyType
    associatedtype R
    func commit(param: T) -> R?
    func dispatch(param: T, finish: @escaping (Result<R, Error>) -> ())
}

/// 执行者 通用规范
public protocol StrategyHandler {
}

/// 同步执行者
public protocol StrategyMutation: StrategyHandler {
    associatedtype T
    associatedtype R
    func apply(param: T) -> R?
}

/// 异步执行者
public protocol StrategyAction: StrategyHandler {
    associatedtype T
    associatedtype R
    func process(param: T, finish: @escaping (Result<R, Error>) -> ())
}

/// 存储key和handler的映射
public protocol StrategyHandlerMapper {
    associatedtype T where T: Hashable
    func get(param: T) -> StrategyHandler?
    mutating func register(param: T, handler: StrategyHandler?)
}

/// handler映射的 key值类型
public protocol StrategyHandlerMapperKeyType {
    associatedtype K: Hashable
    var mapperKey: K { get }
}

/// 为所有的 hashable  实现协议默认方法
public extension StrategyHandlerMapperKeyType where Self: Hashable {
    var mapperKey: Self {
        self
    }
}

/// 扩展常用的类型遵守StrategyHandlerMapperKeyType协议
extension String: StrategyHandlerMapperKeyType {}
extension Int: StrategyHandlerMapperKeyType {}

/// 通用的Mapper
open class CommonHandlerMapper<T>: StrategyHandlerMapper where T: Hashable  {
    private var mapper: [T: StrategyHandler] = [:]
    
    open func get(param: T) -> StrategyHandler? {
        mapper[param]
    }
    
    open func register(param: T, handler: StrategyHandler?) {
        mapper[param] = handler
    }
    
    init() {
    }
}

/// 抽象的同步任务执行者，需要继承使用
open class AbstractStrategyMutation<T, R>: StrategyMutation {
    public init() {}
    
    open func apply(param: T) -> R? {
        return nil
    }
}

/// 抽象的异步任务执行者，需要继承使用
open class AbstractStrategyAction<T, R>: StrategyAction {
    open func process(param: T, finish: @escaping (Result<R, Error>) -> ()) {
        finish(Result<R, Error>.failure(NSError(domain: "com.AbstractStrategyAction.common", code: -1, userInfo: nil)))
    }
}

/// 通用的决策者 虽然可以单独使用， 但建议继承使用， 实现registerDefault方法
open class CommonStrategyDecision<T, R>: StrategyDecision where T: StrategyHandlerMapperKeyType {
    public typealias ChildDecision = CommonStrategyDecision<T, R> & StrategyHandler

    public var handlerMapper = CommonHandlerMapper<T.K>()
    
    public init() {
        registerDefault()
    }
    
    open func registerDefault() {
    }
    
    open func childDecision(for key: T.K) -> ChildDecision? {
        return handlerMapper.get(param: key) as? ChildDecision
    }
    
    open func commit(param: T) -> R? {
        if let mutation = handlerMapper.get(param: param.mapperKey) as? AbstractStrategyMutation<T, R> {
            return mutation.apply(param: param)
        }
        if let child = childDecision(for: param.mapperKey) {
            return child.commit(param: param)
        }
        return nil
    }
    
    open func dispatch(param: T, finish: @escaping (Result<R, Error>) -> ()) {
        if let mutation = handlerMapper.get(param: param.mapperKey) as? AbstractStrategyAction<T, R> {
            return mutation.process(param: param, finish: finish)
        }
        if let child = childDecision(for: param.mapperKey) {
            return child.dispatch(param: param, finish: finish)
        }
    }
}
