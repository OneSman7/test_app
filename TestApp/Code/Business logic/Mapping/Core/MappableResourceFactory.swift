//
//  MappableResourceFactory.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Фабрика ресурсов, поддерживающих маппинг
class MappableResourceFactory {
    
    /// Создать ресурс
    ///
    /// - parameter type: тип ресурса
    ///
    /// - returns: ресурс запрашиваемого типа
    static func createResource<Resource: MappableResource>(ofType type: Resource.Type) -> Resource {
        return Resource()
    }
    
    /// Создать массив для хранения ресурсов определенного типа
    ///
    /// - parameter type: тип ресурса
    ///
    /// - returns: созданный массив
    static func createResourceArray<Resource: MappableResource>(forValuesOfType type: Resource.Type) -> [Resource] {
        return [Resource]()
    }
}
