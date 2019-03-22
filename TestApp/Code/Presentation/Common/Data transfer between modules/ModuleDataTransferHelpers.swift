//
//  ModuleDataTransferHelpers.swift
//  Portable
//
//  Created by Ivan Erasov on 09.08.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

/// Вспомогательные методы, облегчающие реализацию протокола DataTransferModuleController в разных наследниках NSViewController / UIViewController
public extension UIViewController {
    
    /// Набор блоков конфигурации для модулей, разбитый на группы по контроллеру (ключ - хэш контроллера)
    fileprivate static var configurationClosures: [Int : [String: ModuleConfigurationClosure]] = [:]
    
    /// Получаем блок конфигурации модуля для конкретного перехода (вспомогательный метод)
    ///
    /// - Parameter segueIdentifier: идентификатор перехода
    /// - Returns: блок конфигурации модуля (если есть)
    fileprivate func moduleConfigurationClosure(for segueIdentifier: String) -> ModuleConfigurationClosure? {
        return UIViewController.configurationClosures[hashValue]?[segueIdentifier]
    }
    
    /// Устанавливаем блок конфигурации модуля для конкретного перехода (вспомогательный метод)
    ///
    /// - Parameters:
    ///   - configurationClosure: блок конфигурации модуля
    ///   - segueIdentifier: идентификатор перехода
    fileprivate func setModuleConfiguration(configurationClosure: ModuleConfigurationClosure?, for segueIdentifier: String) {
        
        let hashKey = hashValue
        
        if UIViewController.configurationClosures[hashKey] == nil {
            UIViewController.configurationClosures[hashKey] = [String: ModuleConfigurationClosure]()
        }
        
        UIViewController.configurationClosures[hashKey]![segueIdentifier] = configurationClosure
    }
    
    /// Добавить блок конфигурации модуля для конкретного перехода
    ///
    /// - Parameters:
    ///   - configurationClosure: блок конфигурации модуля
    ///   - segueIdentifier: идентификатор перехода
    public func addModuleConfiguration(configurationClosure: @escaping ModuleConfigurationClosure, for segueIdentifier: String) {
        setModuleConfiguration(configurationClosure: configurationClosure, for: segueIdentifier)
    }
    
    /// Вызвать блок конфигурации модуля, если он определен
    ///
    /// - Parameter segue: текущий переход
    public func performModuleConfigurationIfNeeded(for segue: UIStoryboardSegue) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        guard let closure = moduleConfigurationClosure(for: identifier) else {
            return
        }
        
        weak var destinationViewController: UIViewController?
        
        destinationViewController = segue.destination
        
        /// может быть segue в контейнер, добавил проверку на UINavigationController
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.topViewController
        }
        
        
        guard let destination = destinationViewController as? ConfigurableModuleController else {
            return
        }
        
        closure(destination)
        setModuleConfiguration(configurationClosure: nil, for: identifier)
    }
}
