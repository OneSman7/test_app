//
//  MapToDateWithFormatterTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Преобразователь строк с датами в дату
open class MapToDateWithFormatterTransform: MappedValueTransform {
    
    public typealias MappedValueType = Date
    public typealias InputValueType = String
    
    let dateFormatter: DateFormatter //форматтер определяет как будет парсится дата
    let timeZoneAbbreviation = "UTC"
    
    public init(dateFormatter: DateFormatter) {
        dateFormatter.timeZone = TimeZone(abbreviation: timeZoneAbbreviation)
        self.dateFormatter = dateFormatter
    }
    
    open func transformToMappedType(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }
    
    open func transformToInputType(_ value: Any?) -> String? {
        if let date = value as? Date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
