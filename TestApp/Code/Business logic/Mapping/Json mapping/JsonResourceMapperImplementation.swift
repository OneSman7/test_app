//
//  JsonResourceMapperImplementation.swift
//  Portable
//
//  Created by Ivan Erasov on 10.10.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

public class JsonResourceMapperImplementation: JsonResourceMapper {
    
    public init() {}
    
    public func mapJson<Resource: MappableJsonResource>(_ json: NSDictionary, to resource: inout Resource) {
        resource.mapFromJson(json)
    }
    
    public func mapJson<Resource: MappableJsonResource>(_ json: NSDictionary, toResourceOfType type: Resource.Type) -> Resource {
        var resource = MappableResourceFactory.createResource(ofType: type)
        resource.mapFromJson(json)
        return resource
    }
    
    public func mapJsonAsArray<Resource: MappableJsonResource>(_ jsonArray: [NSDictionary], ofResourcesOfType type: Resource.Type) ->[Resource]{
        
        var resourceArray = MappableResourceFactory.createResourceArray(forValuesOfType: type)
        
        for json in jsonArray {
            let resource = mapJson(json, toResourceOfType: type)
            resourceArray.append(resource)
        }
        
        return resourceArray
    }
}
