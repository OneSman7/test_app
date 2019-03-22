//
//  ImageDownloadManagerImplementation.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import UIKit

class ImageDownloadManagerImplementation: ImageDownloadManager {
    
    var fileDownloader: FileDownloadManager!
    var fileCacher: FileCacheManager!
    
    fileprivate let queryCacheQueue: DispatchQueue = DispatchQueue(label: "com.any.app.image.query.cache", qos: .userInitiated)
    
    //MARK: - ImageDownloader
    
    func loadImage(at url: URL?, completion: @escaping ImageDownloadResultHandler) {
        
        guard url != nil else { return }
        
        queryCacheQueue.async { [weak self] in
            
            guard let strongSelf = self else { return }
            let cacheKey = String(url!.hashValue)
            
            if let cacheUrl = strongSelf.fileCacher.cacheUrl(for: cacheKey),
                let image = UIImage(contentsOfFile: cacheUrl.path) {
                
                DispatchQueue.main.async {
                    completion(.success(image: image))
                }
                
                return
            }
            
            strongSelf.fileDownloader.downloadFileReportingOnUtilityThread(fileUrl: url!, completion: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                var loadResult: ImageDownloadResult
                
                defer {
                    DispatchQueue.main.async {
                        completion(loadResult)
                    }
                }
                
                switch result {
                    
                case .success(_, let temporaryFileUrl):
                    
                    guard let image = UIImage(contentsOfFile: temporaryFileUrl.path) else {
                        let error = NSError(domain: NSCocoaErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil)
                        loadResult = .failure(error: error)
                        return
                    }
                    
                    try? strongSelf.fileCacher.addItem(at: temporaryFileUrl, toCacheFor: cacheKey)
                    loadResult = .success(image: image)
                    
                case .failure(let error):
                    loadResult = .failure(error: error)
                }
            })
        }
    }
    
    func cancelLoadImage(at url: URL?) {
        guard url != nil else { return }
        fileDownloader.cancelDownloadForFile(at: url!)
    }
    
    func clearExpiredCacheIfNeeded() {
        fileCacher.clearExpiredCacheIfNeeded()
    }
}
