//
//  FileDownloadManagerImplementation.swift
//  Portable
//
//  Created by Ivan Erasov on 09.11.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

open class FileDownloadManagerImplementation: HTTPSessionDelegate, FileDownloadManager {
    
    /// Название папки с кэшем загруженных файлов
    fileprivate static let fileDownloadCacheDirectoryName = "com.any.app.file.download.cache"
    
    /// Ссылка на папку с кэшем загруженных файлов
    fileprivate static var fileDownloadCacheDirectoryUrl: URL? = {
        
        let fileManager = FileManager()
        let cachesUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        
        return cachesUrl?.appendingPathComponent(fileDownloadCacheDirectoryName)
    }()
    
    /// Запросы на загрузку файлов по веб-ссылке на файл
    fileprivate static var downloadRequestByFileUrl: ThreadSafeDictionary<URL, HTTPDownloadRequest> = ThreadSafeDictionary()
    
    fileprivate typealias Class = FileDownloadManagerImplementation
    
    /// Конфигурация работы с сетью
    open var urlSessionConfiguration: URLSessionConfiguration!
    
    /// Менеджер запросов
    open var requestManager: HTTPRequestManager!
    
    public override init() {}
    
    //MARK: - Helpers
    
    fileprivate func downloadFile(at url: URL, callingCompletionAsync: Bool, completion: @escaping FileDownloadResultHandler) {
        
        guard let cacheDirectoryUrl = Class.fileDownloadCacheDirectoryUrl else {
            completion(.failure(error: FileDownloadError.couldNotCreateDownloadCache))
            return
        }
        
        let fileUrl = cacheDirectoryUrl.appendingPathComponent(url.lastPathComponent)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.GET.rawValue
        
        let request = requestManager.perform(downloadRequest: urlRequest, to: fileUrl)
            .validate(acceptableStatusCodes: [200])
            .response { response in
                
                var result: FileDownloadResult
                
                defer {
                    
                    Class.downloadRequestByFileUrl[url] = nil
                    
                    if callingCompletionAsync {
                        completion(result)
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    }
                }
                
                guard let fileData = response.data else {
                    result = .failure(error: FileDownloadError.emptyFileContents)
                    return
                }
                
                result = .success(data: fileData, temporaryFileUrl: fileUrl)
        }
        
        Class.downloadRequestByFileUrl[url] = request
    }
    
    //MARK: - FileDownloadManager
    
    open func downloadProgressForFile(at url: URL) -> Progress? {
        return Class.downloadRequestByFileUrl[url]?.progress
    }
    
    open func downloadFile(at url: URL, completion: @escaping FileDownloadResultHandler) {
        downloadFile(at: url, callingCompletionAsync: false, completion: completion)
    }
    
    open func downloadFileReportingOnUtilityThread(fileUrl: URL, completion: @escaping FileDownloadResultHandler) {
        downloadFile(at: fileUrl, callingCompletionAsync: true, completion: completion)
    }
    
    open func cancelDownloadForFile(at url: URL) {
        Class.downloadRequestByFileUrl[url]?.cancel()
        Class.downloadRequestByFileUrl[url] = nil
    }
    
    open func clearTemporaryFileCache() {
        
        guard let cacheDirectoryUrl = Class.fileDownloadCacheDirectoryUrl else { return }
        
        // заново папку создаст, если это понадобится, менеджер запросов при выполнении операции загрузки файла
        let fileManager = FileManager()
        try? fileManager.removeItem(at: cacheDirectoryUrl)
    }
}
