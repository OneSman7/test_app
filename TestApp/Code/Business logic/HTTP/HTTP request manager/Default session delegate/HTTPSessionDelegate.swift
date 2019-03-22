//
//  HTTPSessionDelegate.swift
//  Portable
//
//  Created by Ivan Erasov on 08.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Делегат HTTP сессии
open class HTTPSessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    private var taskDelegates: [Int: URLSessionTaskDelegate] = [:]
    private let lock = NSLock()
    
    /// Сабскрипт для получения делегатов задач
    ///
    /// - Parameter task: задача, делегата которой мы хотим получить
    open subscript(task: URLSessionTask) -> URLSessionTaskDelegate? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return taskDelegates[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            taskDelegates[task.taskIdentifier] = newValue
        }
    }
    
    //MARK: - URLSessionDelegate
    
    func dataDelegate(for task: URLSessionDataTask) -> URLSessionDataDelegate? {
        lock.lock() ; defer { lock.unlock() }
        return taskDelegates[task.taskIdentifier] as? URLSessionDataDelegate
    }
    
    func downloadDelegate(for task: URLSessionDownloadTask) -> URLSessionDownloadDelegate? {
        lock.lock() ; defer { lock.unlock() }
        return taskDelegates[task.taskIdentifier] as? URLSessionDownloadDelegate
    }
    
    private func delegate(for task: URLSessionTask, respondsTo selector: Selector) -> Bool {
        return self[task]?.responds(to: selector) ?? false
    }
    
    //MARK: - URLSessionTaskDelegate
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        guard delegate(for: task, respondsTo: #function) else {
            completionHandler(request)
            return
        }
        
        self[task]?.urlSession?(session, task: task, willPerformHTTPRedirection: response, newRequest: request, completionHandler: completionHandler)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard delegate(for: task, respondsTo: #function) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        self[task]?.urlSession?(session, task: task, didReceive: challenge, completionHandler: completionHandler)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        self[task]?.urlSession?(session, task: task, needNewBodyStream: completionHandler)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        self[task]?.urlSession?(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    }
    
    @available(iOS 10.0, macOS 10.12, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        self[task]?.urlSession?(session, task: task, didFinishCollecting: metrics)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self[task]?.urlSession?(session, task: task, didCompleteWithError: error)
    }
    
    //MARK: - URLSessionDataDelegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        guard delegate(for: dataTask, respondsTo: #function) else {
            completionHandler(.allow)
            return
        }
        
        dataDelegate(for: dataTask)?.urlSession?(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        dataDelegate(for: dataTask)?.urlSession?(session, dataTask: dataTask, didBecome: downloadTask)
    }
    
    @available(iOS 9.0, *)
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        dataDelegate(for: dataTask)?.urlSession?(session, dataTask: dataTask, didBecome: streamTask)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataDelegate(for: dataTask)?.urlSession?(session, dataTask: dataTask, didReceive: data)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        
        guard delegate(for: dataTask, respondsTo: #function) else {
            completionHandler(proposedResponse)
            return
        }
        
        dataDelegate(for: dataTask)?.urlSession?(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
    }
    
    //MARK: - URLSessionDownloadDelegate
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        downloadDelegate(for: downloadTask)?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadDelegate(for: downloadTask)?.urlSession?(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        downloadDelegate(for: downloadTask)?.urlSession?(session, downloadTask: downloadTask, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
    }
}
