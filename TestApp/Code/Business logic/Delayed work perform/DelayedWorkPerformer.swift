//
//  DelayedWorkPerformer.swift
//  Portable
//
//  Created by Ivan Erasov on 22.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Компонент для выполнения блока кода с задержкой и возможностью отмены без использования NSObject
open class DelayedWorkPerformer {
    
    /// Выполняемый блок кода
    public typealias Work = () -> ()
    
    fileprivate var workItem: DispatchWorkItem?
    fileprivate let work: Work
    
    public init(work: @escaping Work) {
        self.work = work
    }
    
    //MARK: - Открытые методы
    
    /// Ожидается ли в будущем выполнение блока кода
    fileprivate(set) public var isWorkScheduled = false
    
    /// Выполнить блок кода на текущем потоке
    open func perform() {
        work()
    }
    
    /// Выполнить блок кода асинхронно на другом потоке
    ///
    /// - Parameter qos: quality of service
    open func performAsync(with qos: DispatchQoS.QoSClass = .default) {
        perform(on: DispatchQueue.global(qos: qos), afterDelay: 0)
    }
    
    /// Выполнить блок кода на главном потоке с задержкой
    ///
    /// - Parameter delay: задержка выполнения
    open func performOnMain(afterDelay delay: TimeInterval) {
        perform(on: DispatchQueue.main, afterDelay: delay)
    }
    
    /// Выполнить блок кода на другом потоке с задержкой
    ///
    /// - Parameters:
    ///   - delay: задержка выполнения
    ///   - qos: quality of service
    open func performAsync(afterDelay delay: TimeInterval, with qos: DispatchQoS.QoSClass = .default) {
        perform(on: DispatchQueue.global(qos: qos), afterDelay: delay)
    }
    
    /// Выполнить блок кода асинхронно на конкретной очереди
    ///
    /// - Parameters:
    ///   - queue: очередь выполнения
    ///   - delay: задержка выполнения
    open func perform(on queue: DispatchQueue, afterDelay delay: TimeInterval) {
        
        cancelDelayedPerform()
        isWorkScheduled = true
        
        let item = DispatchWorkItem(block: { [weak self] in
            
            let isCancelled = self?.workItem?.isCancelled ?? true
            
            guard !isCancelled else {
                
                self?.workItem = nil
                self?.isWorkScheduled = false
                
                return
            }
            
            self?.work()
            self?.workItem = nil
            self?.isWorkScheduled = false
        })
        
        workItem = item
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }
    
    /// Отменить текущее выполнение блока кода с задержкой
    open func cancelDelayedPerform() {
        workItem?.cancel()
        workItem = nil
        isWorkScheduled = false
    }
}
