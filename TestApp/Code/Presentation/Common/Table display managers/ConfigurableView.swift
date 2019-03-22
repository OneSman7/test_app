//
//  ConfigurableView.swift
//  Portable
//
//  Created by Ivan Erasov on 25.01.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Протокол конфигурации объектов, использующийся для ячеек/хэдеров/футеров таблицы/collection view
public protocol ConfigurableView {
    
    /// Метод для конфигурации вьюшки с помощью некоторого объекта, конкретный тип которого известен только самой вьюшке
    ///
    /// - Parameter object: объект конфигурации
    func configure(with object: Any)
}
