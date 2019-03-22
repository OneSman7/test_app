//
//  HTTPTaskDelegate.swift
//  Portable
//
//  Created by Ivan Erasov on 08.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Делегат задачи по выполнению запроса HTTP
public protocol HTTPTaskDelegate: URLSessionTaskDelegate {
    
    /// Выполняется ли задача в данный момент
    var isTaskRunning: Bool { get }
    
    /// Приостановлена ли задача в данный момент
    var isTaskSuspended: Bool { get }
    
    /// Данные, полученные при выполнении задачи
    var taskData: Data? { get }
    
    /// Ошибка выполнения задачи
    var taskError: Error? { get set }
    
    /// Обработчик окончания выполнения задачи, вызывается в самом конце после всех completionHandler.
    /// Вызывается НЕ на главном потоке.
    var taskFinishedHandler: ((URLSessionTask) -> Void)? { get set }
    
    /// Инициализатор делегата
    ///
    /// - Parameter task: задача, которую будем выполнять
    init(with task: URLSessionTask)
    
    /// Добавить обработчик, который выполнится после выполнения взаимодействия с сервером.
    /// Обработчик будет выполнен НЕ на главном потоке. Обработчики выполняются последовательно.
    ///
    /// - Parameter completionHandler: обработчик
    func addTaskCompletionHandler(completionHandler: @escaping () -> Void)
    
    /// Приостановить задачу
    func suspendTask()
    
    /// Запустить задачу
    func resumeTask()
    
    /// Отменить задачу
    func cancelTask()
}
