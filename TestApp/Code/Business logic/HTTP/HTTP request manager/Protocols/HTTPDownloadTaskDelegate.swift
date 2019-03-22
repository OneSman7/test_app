//
//  HTTPDownloadTaskDelegate.swift
//  Portable
//
//  Created by Ivan Erasov on 11.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

/// Делегат задачи по выполнению запроса скачивания по HTTP
public protocol HTTPDownloadTaskDelegate: HTTPTaskDelegate {
    
    /// url в файловой системе куда надо поместить скачанный файл
    var destinationURL: URL? { get set }
}
