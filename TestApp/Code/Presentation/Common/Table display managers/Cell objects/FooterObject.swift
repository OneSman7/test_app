//
//  FooterObject.swift
//  Portable
//
//  Created by Ivan Erasov on 25.01.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Протокол объекта конфигурации футеров секций таблицы/collection view
public protocol FooterObject {
    
    /// Метод получения идентификатора вьюшки, которая должна использоваться для отображения соответствующего футера
    ///
    /// - Returns: идентификатор вьюшки
    static func footerReuseIdentifier() -> String
    
    /// Метод получения имени nib футера
    ///
    /// - Returns: имя nib футера
    static func footerNibName() -> String
}

public extension FooterObject {
    
    /// Базовая реализация footerReuseIdentifier
    ///
    /// - Returns: возвращается строковое представление типа, реализующего протокол
    public static func footerReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    /// Базовая реализация footerNibName
    ///
    /// - Returns: возвращается строковое представление типа, реализующего протокол, но, если оно оканчивается на "Object", то этот суффикс обрезается
    public static func footerNibName() -> String {
        
        let cellObjectSuffix = "Object"
        var nibName = String(describing: self)
        
        guard nibName.hasSuffix(cellObjectSuffix) else {
            return nibName
        }
        
        guard let rangeOfSuffix = nibName.range(of: cellObjectSuffix, options: .backwards, range: nil, locale: nil) else {
            return nibName
        }
        
        nibName.removeSubrange(rangeOfSuffix)
        return nibName
    }
}
