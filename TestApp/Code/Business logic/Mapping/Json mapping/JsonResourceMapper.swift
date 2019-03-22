//
//  JsonResourceMapper.swift
//  Portable
//
//  Created by Ivan Erasov on 13.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Протокол маппера ресурсов Json в сущности
public protocol JsonResourceMapper {
    
    /// Произвести маппинг json в готовую сущность
    ///
    /// - parameter json:     json
    /// - parameter resource: сущность
    func mapJson<Resource: MappableJsonResource>(_ json: NSDictionary, to resource: inout Resource)
    
    /// Произвести маппинг json в сущность указанного типа
    ///
    /// - parameter json: json
    /// - parameter type: тип сущности
    ///
    /// - returns: созданная и заполненная сущность
    func mapJson<Resource: MappableJsonResource>(_ json: NSDictionary, toResourceOfType type: Resource.Type) -> Resource
    
    /// Произвести маппинг массива json в массив сущностей указанного типа
    ///
    /// - parameter jsonArray: массив json
    /// - parameter type:      тип сущностей
    ///
    /// - returns: созданный и заполненный массив сущностей
    func mapJsonAsArray<Resource: MappableJsonResource>(_ jsonArray: [NSDictionary], ofResourcesOfType type: Resource.Type) ->[Resource]
}
