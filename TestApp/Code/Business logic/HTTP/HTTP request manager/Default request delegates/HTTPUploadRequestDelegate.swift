//
//  HTTPUploadRequestDelegate.swift
//  Portable
//
//  Created by Ivan Erasov on 11.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPUploadRequestDelegate: HTTPRequestDelegate, URLSessionDataDelegate {
    
    public let progress: Progress = Progress(totalUnitCount: 0)
    
    //MARK: - URLSessionDataDelegate
    
    public func URLSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        progress.totalUnitCount = totalBytesExpectedToSend
        progress.completedUnitCount = totalBytesSent
    }
}
