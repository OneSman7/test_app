//
//  BaseModuleConfigurator.swift
//  Portable
//
//  Created by Ivan Erasov on 31.01.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

/// Протокол обработчика конфигурации модуля
public protocol ModuleConfigurationHandler: class {
    
    /// Коллбэк о том, что конфигурация модуля завершена
    func didFinishModuleConfiguration()
}

/// Базовый класс для конфигураторов модулей, обеспечивает вызов методов конфигурации при инициализации конфигуратора в storyboard
open class BaseModuleConfigurator: NSObject {
    
    @IBOutlet open weak var viewController: UIViewController!
    
    override open func awakeFromNib() {
        configureModule(for: viewController)
        finishModuleConfiguration(for: viewController)
    }
    
    /// Сконфигурировать модуль. В конкретных контроллерах переопределяется.
    ///
    /// - Parameter view: контроллер, для которого надо сконфигурировать модуль
    open func configureModule(for view: UIViewController) {
    }
    
    /// Закончить конфигурацию модуля для контроллера
    ///
    /// - Parameter view: контроллер, для которого сконфигурировали модуль
    open func finishModuleConfiguration(for view: UIViewController) {
        guard let handler = view as? ModuleConfigurationHandler else { return }
        handler.didFinishModuleConfiguration()
    }
}
