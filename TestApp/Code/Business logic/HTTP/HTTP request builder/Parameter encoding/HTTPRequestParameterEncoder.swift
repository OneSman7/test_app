//
//  HTTPRequestParameterEncoder.swift
//  Portable
//
//  Created by Ivan Erasov on 09.02.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Способ кодирования параметров в запрос
///
/// - url:          в виде query string
/// - httpBody:     в теле запроса
/// - json:         в теле запроса в виде json
/// - propertyList: в теле запроса в виде property list
/// - custom->:     свой способ (передается closure)
public enum HTTPRequestParameterEncoding {
    case url
    case httpBody
    case json
    case propertyList(PropertyListSerialization.PropertyListFormat, PropertyListSerialization.WriteOptions)
    case custom((URLRequest, [String: Any]?) -> (URLRequest, Error?))
}

/// Результат работы кодировщика - запрос с параметрами и, возможно, ошибка
public typealias HTTPRequestParameterEncoderResult = (request: URLRequest, error: Error?)

/// Протокол кодировщика параметров запроса
public protocol HTTPRequestParameterEncoder {
    
    /// Используемый способ кодирования
    var encoding: HTTPRequestParameterEncoding { get set }
    /// Разделитель, отделяющий query string от url
    var queryStringDelimiter: String { get }
    /// Разделитель, отделяющий параметры внутри query string
    var queryStringComponentsDelimiter: String { get }
    
    /// Кодируем параметры в запрос
    ///
    /// - parameter request:    запрос
    /// - parameter parameters: параметры, которые хотим закодировать
    ///
    /// - returns: запрос с параметрами и (возможно) ошибка
    func encode(_ request: URLRequest, parameters: [String: Any]?) -> HTTPRequestParameterEncoderResult
    
    /// Кодируем параметры в query string
    ///
    /// - parameter parameters: параметры, которые хотим закодировать
    ///
    /// - returns: query string
    func encodeQueryString(_ parameters: [String: Any]) -> String
}

public extension HTTPRequestParameterEncoder {
    
    /// Возвращает percent-escaped строку согласно RFC 3986
    ///
    /// - parameter string: Строка, которую будем кодировать.
    ///
    /// - returns: Закодированная строка.
    public func escapeString(_ string: String) -> String {
        
        /**
         RFC 3986 утверждает, что следующие символы являются "зарезервированными":
         
         - Основные разделители: ":", "#", "[", "]", "@", "?", "/"
         - Дополнительные разделители: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         
         В секции 3.4 RFC 3986 утверждается, что символы "?" и "/" не должны кодироваться, чтобы query string могли
         включать URL. Таким образом, все "зарезервированные" символы за исключением "?" и "/"
         должны быть закодированы в query string.
         */
        
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching используется из-за бага в iOS 8.1 и 8.2. Кодирование большого числа
        //  китайских символов вызывает различные malloc error креши. Более подробно здесь:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        if #available(iOS 8.3, OSX 10.10, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        }
        else {
            
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                
                let startIndex = index
                
                guard let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) else {
                    break
                }
                
                let range = startIndex ..< endIndex
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
}
