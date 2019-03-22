//
//  MapToEnumTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Преобразователь значений (строки, числа) в enum
open class MapToEnumTransform<T: RawRepresentable>: MappedValueTransform {
    
    public typealias MappedValueType = T
    public typealias InputValueType = T.RawValue
    
    public init() {}
    
    open func transformToMappedType(_ value: Any?) -> T? {
        if let raw = value as? T.RawValue {
            return T(rawValue: raw)
        }
        return nil
    }
    
    open func transformToInputType(_ value: Any?) -> T.RawValue? {
        if let obj = value as? T {
            return obj.rawValue
        }
        return nil
    }
}
