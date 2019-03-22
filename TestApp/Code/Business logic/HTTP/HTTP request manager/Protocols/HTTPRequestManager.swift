//
//  HTTPRequestManager.swift
//  Portable
//
//  Created by Ivan Erasov on 31.10.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Протокол менеджера запросов по HTTP
public protocol HTTPRequestManager {
    
    /// Создаем менеджер
    ///
    /// - Parameters:
    ///   - configuration: конфигурация сессии
    ///   - delegate: делегат сессии
    init(with configuration: URLSessionConfiguration, and delegate: HTTPSessionDelegate)
    
    /// используемый по умолчанию тип делегата для обычных задач
    var dataRequestDelegateType: HTTPTaskDelegate.Type { get set }
    
    /// используемый по умолчанию тип делегата для задач на скачивание
    var downloadRequestDelegateType: HTTPDownloadTaskDelegate.Type { get set }
    
    /// используемый по умолчанию тип делегата для задач на загрузку файлов на сервер
    var uploadRequestDelegateType: HTTPTaskDelegate.Type { get set }
    
    /// Выполнить запрос
    ///
    /// - Parameter dataRequest: параметры запроса
    /// - Returns: объект, позволяющий управлять запросом
    func perform(dataRequest: URLRequest) -> HTTPRequest
    
    /// Выполнить запрос
    ///
    /// - Parameters:
    ///   - dataRequest: параметры запроса
    ///   - delegateType: тип делагата для создаваемой задачи
    /// - Returns: объект, позволяющий управлять запросом
    func perform(dataRequest: URLRequest, with delegateType: HTTPTaskDelegate.Type) -> HTTPRequest
    
    /// Выполнить запрос на скачивание
    ///
    /// - Parameters:
    ///   - downloadRequest: параметры запроса
    ///   - url: url в файловой системе, куда надо переместить скачанный файл
    /// - Returns: объект, позволяющий управлять запросом
    func perform(downloadRequest: URLRequest, to url: URL) -> HTTPDownloadRequest
    
    /// Возобновить запрос на скачивание
    ///
    /// - Parameters:
    ///   - resumeData: данные для возобновления скачивания
    ///   - url: url в файловой системе, куда надо переместить скачанный файл
    /// - Returns: объект, позволяющий управлять запросом
    func resume(downloadWith resumeData: Data, to url: URL) -> HTTPDownloadRequest
    
    /// Выполнить запрос на скачивание
    ///
    /// - Parameters:
    ///   - downloadRequest: параметры запроса
    ///   - url: url в файловой системе, куда надо переместить скачанный файл
    ///   - delegateType: тип делагата для создаваемой задачи
    /// - Returns: объект, позволяющий управлять запросом
    func perform(downloadRequest: URLRequest, to url: URL, with delegateType: HTTPDownloadTaskDelegate.Type) -> HTTPDownloadRequest
    
    /// Возобновить запрос на скачивание
    ///
    /// - Parameters:
    ///   - resumeData: данные для возобновления скачивания
    ///   - url: url в файловой системе, куда надо переместить скачанный файл
    ///   - delegateType: тип делагата для создаваемой задачи
    /// - Returns: объект, позволяющий управлять запросом
    func resume(downloadWith resumeData: Data, to url: URL, with delegateType: HTTPDownloadTaskDelegate.Type) -> HTTPDownloadRequest
    
    /// Выполнить запрос на загрузку файла на сервер
    ///
    /// - Parameters:
    ///   - uploadRequest: параметры запроса
    ///   - bodyData: набор байтов, который надо передать
    /// - Returns: объект, позволяющий управлять запросом
    func perform(uploadRequest: URLRequest, from bodyData: Data) -> HTTPUploadRequest
    
    /// Выполнить запрос на загрузку файла на сервер
    ///
    /// - Parameters:
    ///   - uploadRequest: параметры запроса
    ///   - fileUrl: url в файловой системе, по которому располагается загружаемый файл
    /// - Returns: объект, позволяющий управлять запросом
    func perform(uploadRequest: URLRequest, fromFile fileUrl: URL) -> HTTPUploadRequest
    
    /// Выполнить запрос на загрузку файла на сервер
    ///
    /// - Parameters:
    ///   - uploadRequest: параметры запроса
    ///   - bodyData: набор байтов, который надо передать
    ///   - delegateType: тип делагата для создаваемой задачи
    /// - Returns: объект, позволяющий управлять запросом
    func perform(uploadRequest: URLRequest, from bodyData: Data, with delegateType: HTTPTaskDelegate.Type) -> HTTPUploadRequest
    
    /// Выполнить запрос на загрузку файла на сервер
    ///
    /// - Parameters:
    ///   - uploadRequest: параметры запроса
    ///   - fileUrl: url в файловой системе, по которому располагается загружаемый файл
    ///   - delegateType: тип делагата для создаваемой задачи
    /// - Returns: объект, позволяющий управлять запросом
    func perform(uploadRequest: URLRequest, fromFile fileUrl: URL, with delegateType: HTTPTaskDelegate.Type) -> HTTPUploadRequest
}
