//
//  SerializableJsonResource.swift
//  Portable
//
//  Created by Ivan Erasov on 12.05.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Протокол ресурса, который умеет сериализоваться в json
public protocol SerializableJsonResource {
    
    /// Метод сериализации ресурса
    ///
    /// - Returns: json-представление ресурса
    func serializeToJson() -> NSDictionary
}
