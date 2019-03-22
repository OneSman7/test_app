//
//  MappableResource.swift
//  Portable
//
//  Created by Ivan Erasov on 10.10.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Протокол ресурса, который умеет маппиться
public protocol MappableResource {
    
    /// Такие ресурсы обладают конструктором без параметров, чтобы их могла создавать фабрика
    init()
}
