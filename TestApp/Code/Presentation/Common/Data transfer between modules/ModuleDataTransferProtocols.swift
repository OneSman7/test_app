//
//  ModuleDataTransferProtocols.swift
//  Portable
//
//  Created by Ivan Erasov on 27.01.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Сlosure настройки модуля
public typealias ModuleConfigurationClosure = (_ destination: ConfigurableModuleController) -> Void

/// Протокол контроллера, который передает данные
public protocol DataTransferModuleController: class  {
    
    /// Вызвать segue для перехода между модулями и передать данные
    ///
    /// - Parameters:
    ///   - identifier: идентификатор segue
    ///   - sender: объект, вызывающий переход
    ///   - configurationClosure: closure настройки вызываемого модуля
    func performSegue(with identifier: String, sender: AnyObject?, configurationClosure: ModuleConfigurationClosure?)
}

/// Протокол контроллера настраиваемого модуля
public protocol ConfigurableModuleController: class {
    
    /// Настроить модуль
    ///
    /// - Parameter object: объект с данными
    func configureModule(with object: Any)
}
