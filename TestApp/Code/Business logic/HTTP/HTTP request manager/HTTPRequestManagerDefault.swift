//
//  HTTPRequestManagerDefault.swift
//  Portable
//
//  Created by Ivan Erasov on 01.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPRequestManagerDefault: HTTPRequestManager {
    
    private let session: URLSession
    private let sessionDelegate: HTTPSessionDelegate
    
    private var requests: [Int: HTTPRequest] = [:]
    private let lock = NSLock()
    
    private subscript(task: URLSessionTask) -> HTTPRequest? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }
    
    required public init(with configuration: URLSessionConfiguration, and delegate: HTTPSessionDelegate) {
        sessionDelegate = delegate
        session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    public var dataRequestDelegateType: HTTPTaskDelegate.Type = HTTPDataRequestDelegate.self
    public var downloadRequestDelegateType: HTTPDownloadTaskDelegate.Type = HTTPDownloadRequestDelegate.self
    public var uploadRequestDelegateType: HTTPTaskDelegate.Type = HTTPUploadRequestDelegate.self
    
    public func perform(dataRequest: URLRequest) -> HTTPRequest {
        return perform(dataRequest: dataRequest, with: dataRequestDelegateType)
    }
    
    public func perform(dataRequest: URLRequest, with delegateType: HTTPTaskDelegate.Type) -> HTTPRequest {
        
        let task = session.dataTask(with: dataRequest)
        let delegate = delegateType.init(with: task)
        let request = HTTPRequestDefault(with: task, and: delegate)
        
        sessionDelegate[task] = delegate
        self[task] = request
        
        delegate.taskFinishedHandler = { [weak self] task in
            self?.sessionDelegate[task] = nil
            self?[task] = nil
        }
        
        request.resume()
        
        return request
    }
    
    public func perform(downloadRequest: URLRequest, to url: URL) -> HTTPDownloadRequest {
        return perform(downloadRequest: downloadRequest, to: url, with: downloadRequestDelegateType)
    }
    
    public func resume(downloadWith resumeData: Data, to url: URL) -> HTTPDownloadRequest {
        return resume(downloadWith: resumeData, to: url, with: downloadRequestDelegateType)
    }
    
    public func perform(downloadRequest: URLRequest, to url: URL, with delegateType: HTTPDownloadTaskDelegate.Type) -> HTTPDownloadRequest {
        let task = session.downloadTask(with: downloadRequest)
        return perform(downloadTask: task, to: url, with: delegateType)
    }
    
    public func resume(downloadWith resumeData: Data, to url: URL, with delegateType: HTTPDownloadTaskDelegate.Type) -> HTTPDownloadRequest {
        let task = session.downloadTask(withResumeData: resumeData)
        return perform(downloadTask: task, to: url, with: delegateType)
    }
    
    private func perform(downloadTask: URLSessionDownloadTask, to url: URL, with delegateType: HTTPDownloadTaskDelegate.Type) -> HTTPDownloadRequest {
        
        let delegate = delegateType.init(with: downloadTask)
        let request = HTTPDownloadRequestDefault(with: downloadTask, and: delegate)
        
        delegate.destinationURL = url
        
        sessionDelegate[downloadTask] = delegate
        self[downloadTask] = request
        
        delegate.taskFinishedHandler = { [weak self] task in
            self?.sessionDelegate[task] = nil
            self?[task] = nil
        }
        
        request.resume()
        
        return request
    }
    
    public func perform(uploadRequest: URLRequest, from bodyData: Data) -> HTTPUploadRequest {
        return perform(uploadRequest: uploadRequest, from: bodyData, with: uploadRequestDelegateType)
    }
    
    public func perform(uploadRequest: URLRequest, fromFile fileUrl: URL) -> HTTPUploadRequest {
        return perform(uploadRequest: uploadRequest, fromFile: fileUrl, with: uploadRequestDelegateType)
    }
    
    public func perform(uploadRequest: URLRequest, from bodyData: Data, with delegateType: HTTPTaskDelegate.Type) -> HTTPUploadRequest {
        let task = session.uploadTask(with: uploadRequest, from: bodyData)
        return perform(uploadTask: task, with: delegateType)
    }
    
    public func perform(uploadRequest: URLRequest, fromFile fileUrl: URL, with delegateType: HTTPTaskDelegate.Type) -> HTTPUploadRequest {
        let task = session.uploadTask(with: uploadRequest, fromFile: fileUrl)
        return perform(uploadTask: task, with: delegateType)
    }
    
    private func perform(uploadTask: URLSessionUploadTask, with delegateType: HTTPTaskDelegate.Type) -> HTTPUploadRequest {
        
        let delegate = delegateType.init(with: uploadTask)
        let request = HTTPUploadRequestDefault(with: uploadTask, and: delegate)
        
        sessionDelegate[uploadTask] = delegate
        self[uploadTask] = request
        
        delegate.taskFinishedHandler = { [weak self] task in
            self?.sessionDelegate[task] = nil
            self?[task] = nil
        }
        
        request.resume()
        
        return request
    }
}
