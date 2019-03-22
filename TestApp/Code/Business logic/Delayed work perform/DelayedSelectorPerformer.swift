//
//  DelayedSelectorPerformer.swift
//  Portable
//
//  Created by Ivan Erasov on 30.08.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Компонент для вызова селектора с задержкой без удержания strong ссылки на target
open class DelayedSelectorPerformer: NSObject {
    
    /// Настоящий target
    fileprivate(set) weak var realPerformer: NSObject?
    
    public let selector: Selector
    public var argument: Any?
    
    public init(target: NSObject, selector: Selector) {
        realPerformer = target
        self.selector = selector
    }
    
    /// Вызвать селектор с задержкой
    ///
    /// - Parameter delay: задержка
    open func perform(afterDelay delay: TimeInterval) {
        perform(#selector(delayedSelector(argument:)), with: argument, afterDelay: delay)
    }
    
    /// Отменить вызов селектора
    open func cancelDelayedPerform() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayedSelector(argument:)), object: argument)
    }
    
    @objc
    fileprivate func delayedSelector(argument: Any?) {
        guard let performer = realPerformer else { return }
        performer.perform(selector, with: argument)
    }
}
