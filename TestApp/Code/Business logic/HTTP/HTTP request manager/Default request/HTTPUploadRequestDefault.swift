//
//  HTTPUploadRequestDefault.swift
//  Portable
//
//  Created by Ivan Erasov on 11.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPUploadRequestDefault: HTTPRequestDefault, HTTPUploadRequest {
    
    private var uploadDelegate: HTTPUploadRequestDelegate?
    
    //MARK: - HTTPUploadRequest
    
    public var progress: Progress? { return uploadDelegate?.progress }
    
    override init(with task: URLSessionTask, and delegate: HTTPTaskDelegate) {
        super.init(with: task, and: delegate)
        uploadDelegate = delegate as? HTTPUploadRequestDelegate
    }
}
