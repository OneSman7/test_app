//
//  MapToGenericTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Generic преобразователь значений, позволяет задавать преобразования через closures
open class MapToGenericTransform<MappedType, InputType>: MappedValueTransform {
    
    public typealias MappedValueType = MappedType
    public typealias InputValueType = InputType
    
    fileprivate let toMapped: (InputType?) -> MappedType?
    fileprivate let toInput: (MappedType?) -> InputType?
    
    public init(toMapped: @escaping (InputType?) -> MappedType?, toInput: @escaping (MappedType?) -> InputType?) {
        self.toMapped = toMapped
        self.toInput = toInput
    }
    
    open func transformToMappedType(_ value: Any?) -> MappedType? {
        return toMapped(value as? InputType)
    }
    
    open func transformToInputType(_ value: Any?) -> InputType? {
        return toInput(value as? MappedType)
    }
}
