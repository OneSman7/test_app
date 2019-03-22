//
//  FileCacheManagerImplementation.swift
//  Portable
//
//  Created by Ivan Erasov on 28.11.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

open class FileCacheManagerImplementation: FileCacheManager {
    
    public let configuration: FileCacheConfiguration
    
    /// Ссылка на папку с кэшем
    public let cacheDirectoryUrl: URL?
    
    /// Ссылки на файлы в кэше по ключу кэширования
    fileprivate let cacheUrlByKey: ThreadSafeDictionary<String, URL>
    
    fileprivate let fileManager = FileManager()
    
    /// Обработчик создания файла (параметр - путь, где надо создать файл)
    fileprivate typealias FileCacheCreationClosure = (_ filePath: String) throws -> ()
    
    //MARK: - Приватные методы
    
    /// Заполнить ссылки на файлы в кэше по ключу кэширования (прочитав содержимое папки)
    fileprivate func populateCacheUrlsByKey() {
        
        guard let directoryUrl = cacheDirectoryUrl else {
            return
        }
        
        guard let files = try? fileManager.contentsOfDirectory(at: directoryUrl,
                                                               includingPropertiesForKeys: nil,
                                                               options: []) else {
                                                                return
        }
        
        for file in files {
            cacheUrlByKey[file.lastPathComponent] = file
        }
    }
    
    /// Создать папку с кэшом
    ///
    /// - Throws: ошибка создания папки
    fileprivate func createCacheDirectoryIfNeeded() throws {
        
        guard let directoryUrl = cacheDirectoryUrl else {
            throw FileCacheError.couldNotLocateCache
        }
        
        try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Закэшировать данные
    ///
    /// - Parameters:
    ///   - fileCreationClosure: обработчик создания файла в кэше
    ///   - key: ключ
    ///   - expiry: настройка устаревания файла в кэше
    /// - Throws: возможная ошибка добавления файла в кэш
    fileprivate func cacheFile(with fileCreationClosure: FileCacheCreationClosure,
                               for key: String,
                               expiry: FileCacheExpiry?) throws {
        
        guard let directoryUrl = cacheDirectoryUrl else {
            throw FileCacheError.couldNotLocateCache
        }
        
        try createCacheDirectoryIfNeeded()
        
        let expiryValue = expiry ?? configuration.expiry
        let fileUrl = directoryUrl.appendingPathComponent(key)
        let filePath = fileUrl.path
        
        try fileCreationClosure(filePath)
        
        try fileManager.setAttributes([.modificationDate : expiryValue.date], ofItemAtPath: filePath)
        
        cacheUrlByKey[key] = fileUrl
    }
    
    /// Добавить данные в кэш
    ///
    /// - Parameters:
    ///   - data: данные, которые будут сохранены в файл в кэше
    ///   - key: ключ
    ///   - expiry: настройка устаревания файла в кэше (если есть)
    /// - Throws: возможная ошибка добавления данных в кэш
    fileprivate func cache(data: Data, for key: String, expiry: FileCacheExpiry?) throws {
        try cacheFile(with: { filePath in
            guard fileManager.createFile(atPath: filePath, contents: data, attributes: nil) else {
                throw FileCacheError.couldNotCreateCacheFile
            }
        }, for: key, expiry: expiry)
    }
    
    /// Добавить файл в кэш
    ///
    /// - Parameters:
    ///   - url: местоположение файла в файловой системе
    ///   - key: ключ
    ///   - expiry: настройка устаревания файла в кэше (если есть)
    /// - Throws: возможная ошибка добавления данных в кэш
    fileprivate func cacheFile(at url: URL, for key: String, expiry: FileCacheExpiry?) throws {
        try cacheFile(with: { filePath in
            try fileManager.copyItem(atPath: url.path, toPath: filePath)
        }, for: key, expiry: expiry)
    }
    
    //MARK: - FileCacheManager
    
    open var totalCacheSize: UInt64 {
        
        var size: UInt64 = 0
        let contents = cacheUrlByKey.currentValues()
        
        for url in contents {
            if let attributes = try? fileManager.attributesOfItem(atPath: url.path),
               let fileSize = attributes[.size] as? NSNumber {
                size += fileSize.uint64Value
            }
        }
        
        return size
    }
    
    required public init(with configuration: FileCacheConfiguration) {
        
        var directoryParentUrl: URL?
        
        if configuration.directory != nil {
            directoryParentUrl = configuration.directory
        }
        else {
            directoryParentUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        }
    
        self.configuration = configuration
        self.cacheUrlByKey = ThreadSafeDictionary()
        self.cacheDirectoryUrl = directoryParentUrl?.appendingPathComponent(configuration.name)
        
        if let protectionType = configuration.protectionType, cacheDirectoryUrl != nil {
            try? fileManager.setAttributes([.protectionKey: protectionType], ofItemAtPath: cacheDirectoryUrl!.path)
        }
        
        populateCacheUrlsByKey()
    }
    
    open func cacheUrl(for key: String) -> URL? {
        return cacheUrlByKey[key]
    }
    
    open func addCache(with data: Data, for key: String) throws {
        try cache(data: data, for: key, expiry: nil)
    }
    
    open func addCache(with data: Data, for key: String, expiry: FileCacheExpiry) throws {
        try cache(data: data, for: key, expiry: expiry)
    }
    
    open func addItem(at url: URL, toCacheFor key: String) throws {
        try cacheFile(at: url, for: key, expiry: nil)
    }
    
    open func addItem(at url: URL, toCacheFor key: String, expiry: FileCacheExpiry) throws {
        try cacheFile(at: url, for: key, expiry: expiry)
    }
    
    open func removeCache(for key: String) throws {
        
        guard let fileUrl = cacheUrl(for: key) else {
            return
        }
        
        try fileManager.removeItem(at: fileUrl)
        cacheUrlByKey[key] = nil
    }
    
    open func clearCache() throws {
        
        guard let directoryUrl = cacheDirectoryUrl else {
            return
        }
        
        try fileManager.removeItem(at: directoryUrl)
        cacheUrlByKey.removeAll()
    }
    
    open func compressCacheIfNeeded() {
        
        let contents = cacheUrlByKey.currentValues()
        
        for url in contents {
            
            if let attributes = try? fileManager.attributesOfItem(atPath: url.path),
               let expiryDate = attributes[.modificationDate] as? Date,
               expiryDate.timeIntervalSinceNow < 0 {
            
                // do-catch, чтобы удалять из словаря cacheUrlByKey только в случае успешного удаления файла
                do {
                    try fileManager.removeItem(at: url)
                    cacheUrlByKey[url.lastPathComponent] = nil
                }
                catch(_) {}
            }
        }
    }
    
    open func clearExpiredCacheIfNeeded() {
        
        var cacheSize = totalCacheSize
        
        guard configuration.maxSize > 0 && cacheSize > configuration.maxSize else {
            return
        }
        
        let targetSize = configuration.maxSize / 2
        let sortedContents = cacheUrlByKey.currentValues().sorted { firstUrl, secondUrl in
            
            guard let firstAttributes = try? fileManager.attributesOfItem(atPath: firstUrl.path),
                  let firstExpiryDate = firstAttributes[.modificationDate] as? Date else {
                    return false
            }
            
            guard let secondAttributes = try? fileManager.attributesOfItem(atPath: secondUrl.path),
                  let secondExpiryDate = secondAttributes[.modificationDate] as? Date else {
                    return false
            }
            
            return firstExpiryDate > secondExpiryDate
        }
        
        for fileUrl in sortedContents {
            
            // do-catch, чтобы удалять из словаря cacheUrlByKey только в случае успешного удаления файла
            do {
                
                let fileAttributes = try fileManager.attributesOfItem(atPath: fileUrl.path)
                let fileSize = fileAttributes[.size] as? NSNumber
                
                try fileManager.removeItem(at: fileUrl)
                cacheUrlByKey[fileUrl.lastPathComponent] = nil
                
                if fileSize != nil {
                    cacheSize -= fileSize!.uint64Value
                }
                
                if cacheSize <= targetSize {
                    break
                }
            }
            catch(_) {}
        }
    }
}

fileprivate extension FileCacheExpiry {
    
    /// Дата устаревания файла в кэше
    var date: Date {
        switch self {
        case .never:
            // смотри: http://lists.apple.com/archives/cocoa-dev/2005/Apr/msg01833.html
            return Date(timeIntervalSince1970: 60 * 60 * 24 * 365 * 68)
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
        case .date(let date):
            return date
        }
    }
}
