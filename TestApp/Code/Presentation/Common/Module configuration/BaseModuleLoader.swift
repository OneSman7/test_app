//
//  BaseModuleLoader.swift
//  Portable
//
//  Created by Ivan Erasov on 20.02.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

/// Базовый класс для загрузчиков модулей, обеспечивает вызов методов загрузки и конфигурации модуля т.к. является наследником BaseModuleConfigurator, может применяться как обычный конфигуратор
open class BaseModuleLoader: BaseModuleConfigurator {
    
    /// Загрузить и сконфигурировать модуль
    ///
    /// - Returns: сконфигурированный view controller модуля
    open func loadAndConfigureModule() -> UIViewController {
        
        let controller = loadModuleViewController()
        viewController = controller
        
        configureModule(for: viewController)
        finishModuleConfiguration(for: viewController)
        
        return controller
    }
    
    /// Загрузить view controller модуля. Перегружается наследниками.
    ///
    /// - Returns: загруженный view controller модуля
    open func loadModuleViewController() -> UIViewController {
        return UIViewController()
    }
}
