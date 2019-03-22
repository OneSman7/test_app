//
//  MappedValueTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Протокол преобразователя значений для маппера
public protocol MappedValueTransform {
    
    associatedtype MappedValueType  //тип значения, в который маппим
    associatedtype InputValueType   //тип значения на входе
    
    func transformToMappedType(_ value: Any?) -> MappedValueType?
    func transformToInputType(_ value: Any?) -> InputValueType?
}
