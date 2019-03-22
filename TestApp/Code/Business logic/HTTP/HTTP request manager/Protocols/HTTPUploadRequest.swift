//
//  HTTPUploadRequest.swift
//  Portable
//
//  Created by Ivan Erasov on 11.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Протокол запроса на загрузку файла на сервер по HTTP
public protocol HTTPUploadRequest: HTTPRequest {

    /// Прогресс загрузки файла
    var progress: Progress? { get }
}
