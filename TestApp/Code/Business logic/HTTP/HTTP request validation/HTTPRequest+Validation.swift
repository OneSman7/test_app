//
//  HTTPRequest+Validation.swift
//  Portable
//
//  Created by Ivan Erasov on 23.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Структура, описывающая значения HTTP заголовка Content-Type
fileprivate struct MIMEType {
    
    /// Тип контента
    let type: String
    
    /// Подтип контента
    let subtype: String
    
    /// Разрешает ли значение любой тип контента
    var isWildcard: Bool { return type == "*" && subtype == "*" }
    
    init?(_ string: String) {
        
        let stripped = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let substringToIndex = stripped.range(of: ";")?.lowerBound ?? stripped.endIndex
        let split = stripped[..<substringToIndex]
        let components = split.components(separatedBy: "/")
        
        if let type = components.first, let subtype = components.last {
            self.type = type
            self.subtype = subtype
        } else {
            return nil
        }
    }
    
    /// Разрешается ли переданное значение
    ///
    /// - Parameter mime: переданный тип контента
    func matches(_ mime: MIMEType) -> Bool {
        switch (type, subtype) {
        case (mime.type, mime.subtype), (mime.type, "*"), ("*", mime.subtype), ("*", "*"):
            return true
        default:
            return false
        }
    }
}

public extension HTTPRequest {
    
    /// Валидируем, что статус код HTTP в ответе сервера принадлежит определенному множеству кодов
    ///
    /// - Parameter acceptableStatusCodes: множество кодов
    /// - Returns: тот же запрос, чтобы вызовы можно было chain-ить
    public func validate(acceptableStatusCodes: [Int]) -> Self {
        
        return response(responseHandler: { [weak self] defaultResponse in
            
            guard defaultResponse.error == nil else {
                return
            }
            
            guard let statusCode = defaultResponse.httpUrlResponse?.statusCode else {
                self?.error = HTTPRequestError.statusCodeNotValid
                return
            }
            
            guard acceptableStatusCodes.contains(statusCode) else {
                self?.error = HTTPRequestError.statusCodeNotValid
                return
            }
        })
    }
    
    /// Валидируем, что Content-Type в ответе сервера принадлежит определенному множеству типов контента
    ///
    /// - Parameter acceptableContentTypes: множество типов контента, набор строк из возможных значений HTTP заголовка Content-Type
    /// - Returns: тот же запрос, чтобы вызовы можно было chain-ить
    public func validate(acceptableContentTypes: [String]) -> Self {
        
        return response(responseHandler: { [weak self] defaultResponse in
            
            guard defaultResponse.error == nil else {
                return
            }
            
            guard let data = defaultResponse.data, data.count > 0 else {
                return
            }
            
            guard let responseContentType = defaultResponse.httpUrlResponse?.mimeType, let responseMIMEType = MIMEType(responseContentType) else {
                
                for contentType in acceptableContentTypes {
                    if let mimeType = MIMEType(contentType), mimeType.isWildcard {
                        return
                    }
                }
                
                self?.error = HTTPRequestError.contentTypeNotValid
                return
            }
            
            for contentType in acceptableContentTypes {
                if let acceptableMIMEType = MIMEType(contentType), acceptableMIMEType.matches(responseMIMEType) {
                    return
                }
            }
            
            self?.error = HTTPRequestError.contentTypeNotValid
            return
        })
    }
}
