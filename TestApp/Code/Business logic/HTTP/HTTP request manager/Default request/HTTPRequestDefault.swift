//
//  HTTPRequestDefault.swift
//  Portable
//
//  Created by Ivan Erasov on 09.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPRequestDefault: HTTPRequest {
    
    private let task: URLSessionTask
    private let delegate: HTTPTaskDelegate
    
    //MARK: - HTTPRequest
    
    public init(with task: URLSessionTask, and delegate: HTTPTaskDelegate) {
        self.task = task
        self.delegate = delegate
    }
    
    public var requestIdentifier: Int { return task.taskIdentifier }
    
    public var originalUrlRequest: URLRequest? { return task.originalRequest }
    
    public var currentUrlRequest: URLRequest? { return task.currentRequest }
    
    public var requestDescription: String? { return task.currentRequest?.debugDescription }
    
    public var error: Error? {
        get { return delegate.taskError }
        set { delegate.taskError = error }
    }
    
    public var isRunning: Bool { return delegate.isTaskRunning }
    
    public var isSuspended: Bool { return delegate.isTaskSuspended }
    
    public func suspend() {
        delegate.suspendTask()
    }
    
    public func resume() {
        delegate.resumeTask()
    }
    
    public func cancel() {
        delegate.cancelTask()
    }
    
    public func response(responseHandler: @escaping (HTTPRequestResponse) -> Void) -> Self {
        
        delegate.addTaskCompletionHandler { [weak self] in
            
            guard let strongSelf = self else {
                return
            }

            let response = HTTPRequestResponseDefault(with: strongSelf.task, and: strongSelf.delegate)
            responseHandler(response)
            
            return
        }
        
        return self
    }
}
