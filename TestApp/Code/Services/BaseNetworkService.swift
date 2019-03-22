//
//  BaseNetworkService.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Базовый класс для сервиса, работающего с сетью
class BaseNetworkService: HTTPSessionDelegate {
    
    /// Строитель запросов
    var requestBuilder: HTTPRequestBuilder!
    
    /// Менеджер запросов
    var requestManager: HTTPRequestManager!
    
    /// Маппер JSON в объекты
    var responseMapper: JsonResourceMapper!
    
    /// Конфигурация работы с сетью
    var urlSessionConfiguration: URLSessionConfiguration!
}
