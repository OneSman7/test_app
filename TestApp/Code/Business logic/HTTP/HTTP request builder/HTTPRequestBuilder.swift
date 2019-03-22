//
//  HTTPRequestBuilder.swift
//  Portable
//
//  Created by Ivan Erasov on 09.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/// Перечисление методов HTTP для использования в построении запросов. Значения говорят сами за себя.
public enum HTTPMethod: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

/// Конфигурация запроса HTTP
public struct HTTPRequestConfiguration {
    
    /// метод HTTP
    public var method: String
    
    /// ссылка на ресурс
    public var urlString: String
    
    /// параметры запроса
    public var parameters: [String: Any]?
    
    /// способ кодирования параметров запроса
    public var parametersEncoding: HTTPRequestParameterEncoding = .url
    
    /// параметры для запроса, которые должны кодироваться исключительно как query string
    public var queryStringParameters: [String: Any]?
    
    /// HTTP заголовки запроса
    public var headers: [String: String]?
    
    public init(withMethod method: String, andUrlString urlString: String) {
        
        self.method = method
        self.urlString = urlString
        
        self.parametersEncoding = shouldEncodeParametersInURL(HTTPMethod(rawValue: method)) ? .url : .json
    }
    
    /// Пытаемся понять стоит ли нам кодировать параметры в url как query string
    ///
    /// - parameter method: используемый в запросе метод http
    ///
    /// - returns: кодировать параметры в url как query string или нет
    public func shouldEncodeParametersInURL(_ method: HTTPMethod?) -> Bool {
        
        guard method != nil else {
            return false
        }
        
        switch method! {
        case .GET, .HEAD, .DELETE:
            return true
        default:
            return false
        }
    }
}

/// Протокол строителя запросов HTTP
public protocol HTTPRequestBuilder {
    
    /// ссылка на сервер с АПИ, будет подставлена к ссылке на ресурс, если последняя не является абсолютной ссылкой (проверяется наличие хоста в ссылке)
    var baseURLString: String! { get set }
    
    /// Кодировщик параметров запроса
    var parametersEncoder: HTTPRequestParameterEncoder! { get set }
    
    /// Создать запрос
    ///
    /// - parameter configuration: конфигурация запроса HTTP
    ///
    /// - returns: сформированный запрос
    func request(with configuration: HTTPRequestConfiguration) -> URLRequest
}

public extension HTTPRequestBuilder {
    
    /// Собрать ссылку на ресурс из компонентов, например place/123/info
    ///
    /// - parameter components: компоненты ссылки
    /// - parameter delimiter:  разделитель, по умолчанию используется /
    ///
    /// - returns: сформированная ссылка
    public func pathFromComponents(_ components: [String], delimiter: String = "/") -> String {
        
        var path = ""
        
        for pathComponent in components {
            
            path += pathComponent
            
            guard pathComponent != components.last else { continue }
            guard !pathComponent.hasSuffix(delimiter) else { continue }
            
            path += delimiter
        }
        
        return path
    }
}
