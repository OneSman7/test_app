//
//  MapToUrlFromStringTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 24.05.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Преобразователь строк в URL
open class MapToUrlFromStringTransform: MappedValueTransform {
    
    public typealias MappedValueType = URL
    public typealias InputValueType = String
    
    public init() {}
    
    open func transformToMappedType(_ value: Any?) -> URL? {
        if let urlString = value as? String {
            return URL(string: urlString)
        }
        return nil
    }
    
    open func transformToInputType(_ value: Any?) -> String? {
        if let url = value as? URL {
            return url.absoluteString
        }
        return nil
    }
}
