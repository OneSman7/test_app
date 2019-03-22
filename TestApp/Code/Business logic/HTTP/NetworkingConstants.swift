//
//  NetworkingConstants.swift
//  Portable
//
//  Created by Ivan Erasov on 23.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// таймаут до получения ответа от сервера
public let networkingTimeoutIntervalForRequest: TimeInterval = 15

/// таймаут до завершения работы с запросом
public let networkingTimeoutIntervalForResource: TimeInterval = 40

public enum HTTPRequestContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case html = "text/html"
}

public enum HTTPRequestError: Error {
    
    //валидация
    case statusCodeNotValid
    case contentTypeNotValid
    case emptyContentError
    
    //парсинг
    case jsonParsingNoResponseDataError
    case jsonParsingUnknownError
    
    //маппинг
    case jsonMappingNotExpectedStructure
}
