//
//  HTTPRequest.swift
//  Portable
//
//  Created by Ivan Erasov on 31.10.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Протокол запроса по HTTP
public protocol HTTPRequest: class {
    
    /// Идентификатор запроса
    var requestIdentifier: Int { get }
    
    /// Исходные параметры запроса
    var originalUrlRequest: URLRequest? { get }
    
    /// Текущие параметры запроса (такие же, как originalUrlRequest, если не было редиректов)
    var currentUrlRequest: URLRequest? { get }
    
    /// Описание запроса
    var requestDescription: String? { get }
    
    /// Ошибка запроса
    var error: Error? { get set }
    
    /// Выполняется ли запрос в данный момент
    var isRunning: Bool { get }
    
    /// Приостановлен ли запрос в данный момент
    var isSuspended: Bool { get }
    
    /// Приостановить запрос
    func suspend()
    
    /// Запустить запрос
    func resume()
    
    /// Отменить запрос
    func cancel()
    
    /// Получить ответ
    ///
    /// - Parameter responseHandler: Обработчик, который будет вызыван, когда закончится взаимодействие с сервером и будет получен ответ. Обработчик будет выполнен НЕ на главном потоке.
    /// - Returns: тот же запрос, чтобы вызовы можно было chain-ить
    func response(responseHandler: @escaping (HTTPRequestResponse) -> Void) -> Self
}
