//
//  ServiceBuilder.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Строитель сервисов
protocol ServiceBuilder {
    
    var fileDownloadManager: FileDownloadManager { get }
    
    var defaultFileCacheManager: FileCacheManager { get }
    
    func getITunesService() -> iTunesService
    
    func getLastFmService() -> LastFmService
}
