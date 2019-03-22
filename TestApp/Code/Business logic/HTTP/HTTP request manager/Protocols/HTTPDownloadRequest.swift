//
//  HTTPDownloadRequest.swift
//  Portable
//
//  Created by Ivan Erasov on 11.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Протокол запроса на скачивание по HTTP
public protocol HTTPDownloadRequest: HTTPRequest {
    
    /// Данные для возобновления скачивания позже
    var resumeData: Data? { get }

    /// Прогресс скачивания
    var progress: Progress? { get }
}
