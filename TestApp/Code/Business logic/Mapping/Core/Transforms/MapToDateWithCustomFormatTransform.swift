//
//  MapToDateWithCustomFormatTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Преобразователь строк с датами в произвольном формате в дату
open class MapToDateWithCustomFormatTransform: MapToDateWithFormatterTransform {
    
    fileprivate static let localeIdentifier = "en_US_POSIX"
    fileprivate static let timeZoneAbbreviation = "UTC"
    
    fileprivate static var formattersByFormat = [String : DateFormatter]()
    fileprivate static var formatterGenerator: (String) -> DateFormatter = { formatString in
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.timeZone = TimeZone(abbreviation: timeZoneAbbreviation)
        formatter.dateFormat = formatString
        
        formattersByFormat[formatString] = formatter
        
        return formatter
    }
    
    public init(formatString: String) {
        
        typealias Transform = MapToDateWithCustomFormatTransform
        
        let formatter = Transform.formattersByFormat[formatString] ?? Transform.formatterGenerator(formatString)
        super.init(dateFormatter: formatter)
    }
}
