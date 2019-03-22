//
//  HTTPDownloadRequestDefault.swift
//  Portable
//
//  Created by Ivan Erasov on 11.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPDownloadRequestDefault: HTTPRequestDefault, HTTPDownloadRequest {
    
    private var downloadDelegate: HTTPDownloadRequestDelegate?
    
    //MARK: - HTTPDownloadRequest
    
    public var resumeData: Data? { return downloadDelegate?.resumeData }
    
    public var progress: Progress? { return downloadDelegate?.progress }
    
    override init(with task: URLSessionTask, and delegate: HTTPTaskDelegate) {
        super.init(with: task, and: delegate)
        downloadDelegate = delegate as? HTTPDownloadRequestDelegate
    }
}
