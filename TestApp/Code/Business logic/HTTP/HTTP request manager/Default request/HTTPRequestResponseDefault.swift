//
//  HTTPRequestResponseDefault.swift
//  Portable
//
//  Created by Ivan Erasov on 09.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

public struct HTTPRequestResponseDefault: HTTPRequestResponse {
    
    private let task: URLSessionTask
    private let responseData: Data?
    private let responseError: Error?
    
    public init(with task: URLSessionTask, and delegate: HTTPTaskDelegate) {
        self.task = task
        self.responseData = delegate.taskData
        self.responseError = delegate.taskError
    }
    
    //MARK: - HTTPRequestResponse
    
    public var urlRequest: URLRequest? { return task.originalRequest }
    
    public var httpUrlResponse: HTTPURLResponse? {
        
        guard let response = task.response else {
            return nil
        }
        
        return response as? HTTPURLResponse
    }
    
    public var data: Data? { return responseData }
    
    public var error: Error? { return responseError }
}
