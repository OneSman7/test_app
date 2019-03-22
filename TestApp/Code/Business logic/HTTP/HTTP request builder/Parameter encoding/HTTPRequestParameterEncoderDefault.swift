//
//  HTTPRequestParameterEncoderDefault.swift
//  Portable
//
//  Created by Ivan Erasov on 09.02.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPRequestParameterEncoderDefault: HTTPRequestParameterEncoder {
    
    public var encoding = HTTPRequestParameterEncoding.url
    
    public let queryStringDelimiter = "?"
    public let queryStringComponentsDelimiter = "&"
    
    let contentTypeHTTPHeader = "Content-Type"
    let contentTypeHTTPHeaderFormValue = "application/x-www-form-urlencoded; charset=utf-8"
    let contentTypeHTTPHeaderJsonValue = "application/json"
    let contentTypeHTTPHeaderPlistValue = "application/x-plist"
    
    public init() {}
    
    //MARK: - URLRequestParameterEncoder
    
    public func encode(_ request: URLRequest, parameters: [String: Any]?) -> HTTPRequestParameterEncoderResult {
        
        guard let parameters = parameters, !parameters.isEmpty else {
            return (request, nil)
        }
        
        var mutableURLRequest = request
        var encodingError: Error? = nil
        
        switch encoding {
        case .url:
            if var URLComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false) {
                let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + queryStringComponentsDelimiter } ?? "") + encodeQueryString(parameters)
                URLComponents.percentEncodedQuery = percentEncodedQuery
                mutableURLRequest.url = URLComponents.url
            }
        case .httpBody:
            if mutableURLRequest.value(forHTTPHeaderField: contentTypeHTTPHeader) == nil {
                mutableURLRequest.setValue(contentTypeHTTPHeaderFormValue, forHTTPHeaderField: contentTypeHTTPHeader)
            }
            mutableURLRequest.httpBody = encodeQueryString(parameters).data(using: String.Encoding.utf8, allowLossyConversion: false)
        case .json:
            do {
                let options = JSONSerialization.WritingOptions()
                let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
                mutableURLRequest.setValue(contentTypeHTTPHeaderJsonValue, forHTTPHeaderField: contentTypeHTTPHeader)
                mutableURLRequest.httpBody = data
            }
            catch {
                encodingError = error as Error
            }
        case .propertyList(let format, let options):
            do {
                let data = try PropertyListSerialization.data(fromPropertyList: parameters, format: format, options: options)
                mutableURLRequest.setValue(contentTypeHTTPHeaderPlistValue, forHTTPHeaderField: contentTypeHTTPHeader)
                mutableURLRequest.httpBody = data
            }
            catch {
                encodingError = error as Error
            }
        case .custom(let closure):
            (mutableURLRequest, encodingError) = closure(mutableURLRequest, parameters)
        }
        
        return (mutableURLRequest, encodingError)
    }
    
    public func encodeQueryString(_ parameters: [String: Any]) -> String {
        
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: queryStringComponentsDelimiter)
    }
    
    //MARK: - Приватные методы
    
    /**
     Создает закодированные компоненты query string из переданных пар ключ-значение.
     
     - parameter key:   ключ
     - parameter value: значение
     
     - returns: Закодированные компоненты query string.
     */
    fileprivate func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        }
        else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(key, value)
            }
        }
        else {
            components.append((escapeString(key), escapeString("\(value)")))
        }
        
        return components
    }
}
