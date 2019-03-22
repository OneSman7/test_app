//
//  MappingOperatorJsonExtensions.swift
//  Portable
//
//  Created by Ivan Erasov on 10.10.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

public func << <MappedType: MappableJsonResource>(left: inout MappedType, right: Any?) {
    guard let unwrappedJson = right as? NSDictionary else { return }
    left.mapFromJson(unwrappedJson)
}

//оператор выполнится, если слева у нас MappableJsonResource, его надо создать и замапить или обновить
public func << <MappedType: MappableJsonResource>(left: inout MappedType?, right: Any?) {
    
    guard let unwrappedJson = right as? NSDictionary else { return }
    
    if left != nil {
        left!.mapFromJson(unwrappedJson)
    }
    else {
        
        var resource = MappableResourceFactory.createResource(ofType: MappedType.self)
        resource.mapFromJson(unwrappedJson)
        
        left = resource
    }
}

public func << <MappedType: MappableJsonResource>(left: inout [MappedType], right: Any?) {
    
    //гарантируем вызов реализации оператора с left: MappedType?
    var leftInQuestion: [MappedType]? = left
    leftInQuestion << right
    
    //а почему? а потому, что в милом нашему сердцу Swift полно типов, передающихся не по ссылке :)
    if let leftValue = leftInQuestion {
        left = leftValue
    }
}

//оператор выполнится, если слева у нас [MappableJsonResource], в цикле создаем объекты и мапим их
public func << <MappedType: MappableJsonResource>(left: inout [MappedType]?, right: Any?) {
    
    if let jsonArray = right as? [NSDictionary] {
        
        var objectsArray = MappableResourceFactory.createResourceArray(forValuesOfType: MappedType.self)
        
        for objectJson in jsonArray {
            var object = MappableResourceFactory.createResource(ofType: MappedType.self)
            object.mapFromJson(objectJson)
            objectsArray.append(object)
        }
        
        if !objectsArray.isEmpty {
            left = objectsArray
        }
    }
}

public func << <MappedType: MappableJsonResource>(left: inout [[MappedType]], right: Any?) {
    
    //гарантируем вызов реализации оператора с left: MappedType?
    var leftInQuestion: [[MappedType]]? = left
    leftInQuestion << right
    
    //а почему? а потому, что в милом нашему сердцу Swift полно типов, передающихся не по ссылке :)
    if let leftValue = leftInQuestion {
        left = leftValue
    }
}

//оператор выполнится, если слева у нас [[MappableJsonResource]], в цикле создаем объекты и мапим их
public func << <MappedType: MappableJsonResource>(left: inout [[MappedType]]?, right: Any?) {
    
    if let jsonArray = right as? [[NSDictionary]] {
        
        var arrayOfArrays = [[MappedType]]()
        
        for array in jsonArray {
            
            var objectsArray: [MappedType] = []
            objectsArray << array
            
            arrayOfArrays.append(objectsArray)
        }
        
        if !arrayOfArrays.isEmpty {
            left = arrayOfArrays
        }
    }
}

