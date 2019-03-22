//
//  HTTPRequest+Json.swift
//  Portable
//
//  Created by Ivan Erasov on 23.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Результат парсинга ответа сервера
///
/// - success: успешный парсинг, связанное значение - распарсенный json
/// - failure: ошибка парсинга, связанное значение - ошибка запроса, по причине которой произошел провал парсинга
public enum HTTPResponseJsonParsingResult {
    
    case success(Any)
    case failure(Error)
    
    /// Получить распарсенный json, если парсинг был успешен
    public var jsonObject: Any? {
        switch self {
            case .success(let jsonObject):
                return jsonObject
            default:
                return nil
        }
    }
    
    /// Получить ошибку, если парсинг прошел с ошибкой
    public var error: Error? {
        switch self {
            case .failure(let error):
                return error
            default:
                return nil
        }
    }
}

public extension HTTPRequest {
    
    /// Парсим ответ сервера как json
    ///
    /// - Parameter responseHandler: Обработчик, который будет вызван по окончании парсинга. Обработчик будет выполнен НЕ на главном потоке.
    /// - Returns: тот же запрос, чтобы вызовы можно было chain-ить
    public func responseJson(responseHandler: @escaping (HTTPResponseJsonParsingResult) -> Void) -> Self {
        
        return response(responseHandler: { [weak self] defaultResponse in
            
            var result: HTTPResponseJsonParsingResult
            defer {
                
                if let error = result.error {
                    self?.error = error
                }
                
                responseHandler(result)
            }
            
            guard defaultResponse.error == nil else {
                result = .failure(defaultResponse.error!)
                return
            }
            
            guard let data = defaultResponse.data else {
                result = .failure(HTTPRequestError.jsonParsingNoResponseDataError)
                return
            }
            
            do {
                let parsedJsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                result = .success(parsedJsonObject)
            }
            catch let parsingError as NSError {
                result = .failure(parsingError)
            }
            catch {
                result = .failure(HTTPRequestError.jsonParsingUnknownError)
            }
        })
    }
}
