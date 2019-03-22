//
//  MapToDateFromTimestampTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Преобразователь значений timestamp в дату
open class MapToDateFromTimestampTransform: MappedValueTransform {
    
    public typealias MappedValueType = Date
    public typealias InputValueType = Double
    
    public init() {}
    
    open func transformToMappedType(_ value: Any?) -> Date? {
        if let timeDouble = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeDouble))
        }
        if let timeInt = value as? Int {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }
        return nil
    }
    
    open func transformToInputType(_ value: Any?) -> Double? {
        if let date = value as? Date {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }
}
