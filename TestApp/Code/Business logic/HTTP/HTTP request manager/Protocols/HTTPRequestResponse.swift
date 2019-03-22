//
//  HTTPRequestResponse.swift
//  Portable
//
//  Created by Ivan Erasov on 31.10.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Протокол ответа на запрос по HTTP
public protocol HTTPRequestResponse {
    
    /// параметры запроса
    var urlRequest: URLRequest? { get }
    
    /// параметры ответа (заголовки, http status code итд)
    var httpUrlResponse: HTTPURLResponse? { get }
    
    /// данные, полученные с сервера
    var data: Data? { get }
    
    /// ошибка запроса
    var error: Error? { get }
}
