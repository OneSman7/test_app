//
//  NSDictionaryExtensions.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

public extension NSDictionary {
    
    /// Расширение сабскрипта для словаря, позволяет передавать набор ключей
    ///
    /// - parameter path: variadic параметр, "путь" к объекту
    ///
    /// - returns: объект, находящийся в дереве по указанному пути или nil
    public subscript (path: String...) -> Any? {
        
        //этот сабскрипт вызывается даже при передаче одного ключа (json["key"])
        //пусть для этого случая срабатывает простая логика
        
        var value: Any? = nil
        
        if path.count == 1 {
            value = self.value(forKey: path.first!)
        }
        else {
            value = valueForKeyPathInArray(path: path)
        }
        
        //зачем нам NSNull, когда у нас есть nil?
        return value is NSNull ? nil : value
    }
    
    /// Проходит по дереву в соответствии с переданным путем
    ///
    /// - parameter path: "путь" в дереве, массив ключей
    ///
    /// - returns: объект, находящийся в дереве по указанному пути или nil, если такого пути не существует
    public func valueForKeyPathInArray(path: [String]) -> Any? {
        
        var value: Any? = self
        var json: NSDictionary = self
        
        for pathComponent in path {
            
            if let valueJson = value as? NSDictionary {
                json = valueJson
            }
            else {
                value = nil
                break
            }
            
            value = json.value(forKey: pathComponent)
        }
        
        return value
    }
}
