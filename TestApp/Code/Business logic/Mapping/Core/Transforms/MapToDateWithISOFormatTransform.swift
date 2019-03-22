//
//  MapToDateWithISOFormatTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Преобразователь строк с датами в формате ISO в дату
open class MapToDateWithISOFormatTransform: MapToDateWithCustomFormatTransform {
    
    let dateISOFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    
    public init() {
        super.init(formatString: dateISOFormat)
    }
}
