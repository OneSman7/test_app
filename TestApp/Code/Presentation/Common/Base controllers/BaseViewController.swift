//
//  BaseViewController.swift
//  Portable
//
//  Created by Ivan Erasov on 27.01.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

/// Базовый класс view controller, который реализует дополнительные фишки (например, поддержку передачи данных между модулями)
open class BaseViewController: UIViewController, ModuleConfigurationHandler, DataTransferModuleController {
    
    /// Контроллер, который показывает текущая segue
    /// (источником всегда является текущий контроллер, для unwind здесь будет экран, на который возвращаемся)
    open weak var currentSegueDestination: UIViewController?
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        currentSegueDestination = segue.destination
        performModuleConfigurationIfNeeded(for: segue)
    }
    
    override open var preferredContentSize: CGSize {
        
        get {
            return super.preferredContentSize
        }
        set {
            // нативная реализация почему то передает preferredContentSize только при увеличении
            navigationController?.preferredContentSize = newValue
            super.preferredContentSize = newValue
        }
    }
    
    //MARK: - ModuleConfigurationHandler
    
    open func didFinishModuleConfiguration() {}
    
    //MARK: - DataTransferModuleController
    
    open func performSegue(with identifier: String, sender: AnyObject?, configurationClosure: ModuleConfigurationClosure?) {
        
        if let closure = configurationClosure {
            addModuleConfiguration(configurationClosure: closure, for: identifier)
        }
        
        performSegue(withIdentifier: identifier, sender: sender)
    }
}
