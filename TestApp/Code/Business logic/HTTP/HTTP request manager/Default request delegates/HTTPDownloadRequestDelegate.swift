//
//  HTTPDownloadRequestDelegate.swift
//  Portable
//
//  Created by Ivan Erasov on 08.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPDownloadRequestDelegate: HTTPDataRequestDelegate, HTTPDownloadTaskDelegate, URLSessionDownloadDelegate {
    
    public let progress: Progress = Progress(totalUnitCount: 0)
    
    private(set) var resumeData: Data?
    private(set) var temporaryURL: URL?
    
    //MARK: - HTTPDownloadTaskDelegate
    
    public var destinationURL: URL?
    
    //MARK: - URLSessionDownloadDelegate
    
    override public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let errorValue = error, let resumeData = (errorValue as NSError).userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            self.resumeData = resumeData
        }
        
        super.urlSession(session, task: task, didCompleteWithError: error)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        temporaryURL = location
        
        if let destination = destinationURL {
            
            let fileManager = FileManager()
            
            do {
                
                if fileManager.fileExists(atPath: destination.path) {
                    try fileManager.removeItem(at: destination)
                }
                
                let directory = destination.deletingLastPathComponent()
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                
                try fileManager.moveItem(at: location, to: destination)
            }
            catch {
                taskError = error
            }
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress.totalUnitCount = totalBytesExpectedToWrite
        progress.completedUnitCount = totalBytesWritten
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64,expectedTotalBytes: Int64) {
        progress.totalUnitCount = expectedTotalBytes
        progress.completedUnitCount = fileOffset
    }
}
