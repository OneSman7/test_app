//
//  MappableJsonResource.swift
//  Portable
//
//  Created by Ivan Erasov on 13.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Протокол ресурса, который умеет маппиться из json
public protocol MappableJsonResource: MappableResource {
    
    /// Метод маппинга ресурса. Принимает словарь с атрибутами ресурса. Осуществляет запись данных из json в поля объекта. Мапер вызывает этот метод на каждом объекте-ресурсе, который он встретит в ответе API
    ///
    /// - parameter json: словарь с атрибутами ресурса
    mutating func mapFromJson(_ json: NSDictionary)
}
