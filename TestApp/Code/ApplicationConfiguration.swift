//
//  ApplicationConfiguration.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import UIKit

extension UIApplication {
    
    /// Конфигурация сборки
    ///
    /// - debug: отладка
    /// - release: боевая
    public enum BuildConfiguration: String {
        case debug
        case release
    }
    
    /// Текущая конфигурация сборки
    #if RELEASE
    var buildConfiguration: BuildConfiguration { return .release }
    #else
    var buildConfiguration: BuildConfiguration { return .debug }
    #endif
    
    /// Текущая конфигурация сервисов
    var serviceConfiguration: BuildConfiguration {
        // можно переопределить, чтобы учитывать настройки в самом приложении
        return buildConfiguration
    }
    
    //MARK: - ServiceBuilder
    
    /// Строитель сервисов, для получения экземпляров сервисов в любом месте приложения надо обращаться к нему
    var serviceBuilder: ServiceBuilder {
        recreateServiceBuilderIfNeeded()
        return UIApplication.currentServiceBuilder
    }
    
    /// Текущий закэшированный строитель сервисов
    fileprivate static var currentServiceBuilder: ServiceBuilder!
    
    /// Создаем строитель сервисов согласно текущей конфигурации сервисов
    fileprivate func createServiceBuilder() -> ServiceBuilder {
        return serviceConfiguration == .release ? ServiceBuilderRelease() : ServiceBuilderDebug()
    }
    
    /// Пересоздаем строитель сервисов согласно текущей конфигурации сервисов, если это необходимо
    fileprivate func recreateServiceBuilderIfNeeded() {
        
        // если строитель еще не определен, то просто создаем его
        guard UIApplication.currentServiceBuilder != nil else {
            UIApplication.currentServiceBuilder = createServiceBuilder()
            return
        }
        
        var shouldRecreateServiceBuilder = false
        let usingDebugServiceBuilder = UIApplication.currentServiceBuilder is ServiceBuilderDebug
        
        switch serviceConfiguration {
        case .debug:
            shouldRecreateServiceBuilder = !usingDebugServiceBuilder
        case .release:
            shouldRecreateServiceBuilder = usingDebugServiceBuilder
        }
        
        if shouldRecreateServiceBuilder {
            UIApplication.currentServiceBuilder = createServiceBuilder()
        }
    }
}
