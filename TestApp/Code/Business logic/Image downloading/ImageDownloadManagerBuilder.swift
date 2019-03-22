//
//  ImageDownloadManagerBuilder.swift
//  TestApp
//
//  Created by Иван Ерасов on 22/03/2019.
//

import Foundation

final class ImageDownloadManagerBuilder {
    
    /// Получить shared экземляр менеджера загрузки изображений
    static let sharedManager: ImageDownloadManager = {
        
        let downloadManager = FileDownloadManagerImplementation()
        downloadManager.urlSessionConfiguration = URLSessionConfiguration.default
        downloadManager.requestManager = HTTPRequestManagerDefault(with: downloadManager.urlSessionConfiguration, and: downloadManager)
        
        var configuration = FileCacheConfiguration()
        configuration.name = "com.any.app.image.cache"
        configuration.expiry = .seconds(60 * 60 * 24 * 7)
        
        let cacheManager = FileCacheManagerImplementation(with: configuration)
        
        let manager = ImageDownloadManagerImplementation()
        manager.fileDownloader = downloadManager
        manager.fileCacher = cacheManager
        
        return manager
    }()
}
