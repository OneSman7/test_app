//
//  HTTPRequestDelegate.swift
//  Portable
//
//  Created by Ivan Erasov on 08.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPRequestDelegate: NSObject, HTTPTaskDelegate {
    
    private let queue: OperationQueue
    private let task: URLSessionTask
    
    private var taskCompletedButCompletionHandlersNotFinished: Bool {
        let queueIsNotEmpty = queue.operationCount > 0
        return task.state == .completed && queueIsNotEmpty
    }
    
    private func waitUntilCompletionHandlersFinished() {
        
        let waitQueue = DispatchQueue(label: "ru.mos.http-request-wait-queue-" + UUID().uuidString)
        
        waitQueue.async { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.queue.waitUntilAllOperationsAreFinished()
            strongSelf.taskFinishedHandler?(strongSelf.task)
        }
    }
    
    //MARK: - HTTPTaskDelegate
    
    public var isTaskRunning: Bool {
        
        guard task.state == .running else {
            return true
        }
        
        return taskCompletedButCompletionHandlersNotFinished && !queue.isSuspended
    }
    
    public var isTaskSuspended: Bool {
        
        guard task.state == .suspended else {
            return true
        }
        
        return taskCompletedButCompletionHandlersNotFinished && queue.isSuspended
    }
    
    public var taskData: Data? { return nil }
    public var taskError: Error?
    
    public var taskFinishedHandler: ((URLSessionTask) -> Void)?
    
    required public init(with task: URLSessionTask) {
        
        self.task = task
        
        queue = OperationQueue()
        queue.isSuspended = true
        queue.qualityOfService = .utility
    }
    
    public func addTaskCompletionHandler(completionHandler: @escaping () -> Void) {
        
        let newHandler = BlockOperation(block: completionHandler)
        
        if let lastHandler = queue.operations.last {
            newHandler.addDependency(lastHandler)
        }
        
        queue.addOperation(newHandler)
    }
    
    public func suspendTask() {
        task.suspend()
        queue.isSuspended = true
    }
    
    public func resumeTask() {
        task.resume()
        queue.isSuspended = !taskCompletedButCompletionHandlersNotFinished
    }
    
    public func cancelTask() {
        task.cancel()
        queue.cancelAllOperations()
    }
    
    //MARK: - URLSessionTaskDelegate
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        taskError = error
        queue.isSuspended = false
        
        waitUntilCompletionHandlersFinished()
    }
}
