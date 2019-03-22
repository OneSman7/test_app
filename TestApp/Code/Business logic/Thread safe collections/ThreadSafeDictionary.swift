//
//  ThreadSafeDictionary.swift
//  Portable
//
//  Created by Ivan Erasov on 20.06.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Потокобезопасный словарь (доступ к элементам возможен с разных потоков одновременно)
open class ThreadSafeDictionary<Key: Hashable, Value> {
    
    fileprivate var dictionary = [Key : Value]()
    fileprivate let queue = DispatchQueue(label: "com.any.app.thread.safe.dictionary", attributes: .concurrent)
    
    /// Для синхронизации используется очередь
    /// Чтения выполняются параллельно, вызывающий поток ждет только окончания операции чтения
    /// Записи выполняются последовательно и блокируют другие блоки с помощью барьера, вызывающий поток не ждет окончания операции записи
    /// self захватывается блоками т.к. все равно будет освобожден, а операции короткие
    
    public init() {}
    
    open subscript(key: Key) -> Value? {
        
        set {
            queue.async(flags:.barrier) {
                self.dictionary[key] = newValue
            }
        }
        
        get {
            
            var value: Value?
            
            queue.sync {
                value = dictionary[key]
            }
            
            return value
        }
    }
    
    open var count: Int {
        
        var count: Int!
        
        queue.sync {
            count = dictionary.count
        }
        
        return count
    }
    
    open var isEmpty: Bool {
        
        var isEmpty: Bool!
        
        queue.sync {
            isEmpty = dictionary.isEmpty
        }
        
        return isEmpty
    }
    
    open func currentKeys() -> [Key] {
        
        var keys: [Key]!
        
        queue.sync {
            keys = Array(dictionary.keys)
        }
        
        return keys
    }
    
    open func currentValues() -> [Value] {
        
        var values: [Value]!
        
        queue.sync {
            values = Array(dictionary.values)
        }
        
        return values
    }
    
    open func removeValue(for key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }
    }
    
    open func removeAll() {
        queue.async(flags: .barrier) {
            self.dictionary.removeAll()
        }
    }
}
