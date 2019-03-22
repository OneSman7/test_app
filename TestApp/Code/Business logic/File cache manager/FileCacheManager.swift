//
//  FileCacheManager.swift
//  Portable
//
//  Created by Ivan Erasov on 27.11.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Ошибки работы с кэшем файлов
///
/// - couldNotLocateCache: не удалось обнаружить папку с кэшем
/// - couldNotCreateCacheFile: не удалось создать файл в кэше
public enum FileCacheError: Error {
    case couldNotLocateCache
    case couldNotCreateCacheFile
}

/// Настройка устаревания файла в кэше
///
/// - never: файл не устаревает
/// - seconds: файл устаревает через указанное кол-во секунд
/// - date: файл устаревает в указанную дату
public enum FileCacheExpiry {
    case never
    case seconds(TimeInterval)
    case date(Date)
}

/// Константы для кэша файлов
public struct FileCacheConstants {
    
    /// Название для кэша по умолчанию
    public static let defaultCacheName = "com.any.app.file.cache"
    
    /// Максимальный размер кэша по умолчанию
    public static let defaultCacheMaxSize: UInt64 = UInt64(2e+8) // 200 MB
}

/// Конфигурация кэша файлов
public struct FileCacheConfiguration {
    
    /// Название (папки в directory, где будет располагаться кэш)
    public var name: String = FileCacheConstants.defaultCacheName
    
    /// Настройка устаревания файлов для всего кэша
    /// (будет использована, если при добавлении файла в кэш не указана конкретная настройка)
    public var expiry: FileCacheExpiry = .never
    
    /// Максимальный размер кэша
    public var maxSize: UInt64 = FileCacheConstants.defaultCacheMaxSize
    
    /// Расположение кэша в файловой системе (по умолчанию - папка Caches)
    public var directory: URL?
    
    /// Тип шифрования файла с кэшом (если нужен)
    public var protectionType: FileProtectionType?
    
    public init() {}
}

/// Менеджер для работы с кэшем файлов
/// (не содержит логики генерации ключей для кэша, последняя оставлена на откуп использующего кода)
public protocol FileCacheManager {
    
    /// Текущий размер кэша
    var totalCacheSize: UInt64 { get }
    
    /// Создать менеджер
    ///
    /// - Parameter configuration: конфигурация кэша
    init(with configuration: FileCacheConfiguration)
    
    /// Получить ссылку на файл в кэше по ключу
    ///
    /// - Parameter key: ключ
    /// - Returns: если файл по такому ключу есть в кэше, то вернется ссылка на него, иначе nil
    func cacheUrl(for key: String) -> URL?
    
    /// Добавить данные в кэш
    ///
    /// - Parameters:
    ///   - data: данные, которые будут сохранены в файл в кэше
    ///   - key: ключ
    /// - Throws: возможная ошибка добавления данных в кэш
    func addCache(with data: Data, for key: String) throws
    
    /// Добавить данные в кэш
    ///
    /// - Parameters:
    ///   - data: данные, которые будут сохранены в файл в кэше
    ///   - key: ключ
    ///   - expiry: настройка устаревания файла в кэше
    /// - Throws: возможная ошибка добавления данных в кэш
    func addCache(with data: Data, for key: String, expiry: FileCacheExpiry) throws
    
    /// Добавить файл в кэш
    ///
    /// - Parameters:
    ///   - url: местоположение файла в файловой системе
    ///   - key: ключ
    /// - Throws: возможная ошибка добавления файла в кэш
    func addItem(at url: URL, toCacheFor key: String) throws
    
    /// Добавить файл в кэш
    ///
    /// - Parameters:
    ///   - url: местоположение файла в файловой системе
    ///   - key: ключ
    ///   - expiry: настройка устаревания файла в кэше
    /// - Throws: возможная ошибка добавления файла в кэш
    func addItem(at url: URL, toCacheFor key: String, expiry: FileCacheExpiry) throws
    
    /// Удалить файл из кэша
    ///
    /// - Parameter key: ключ
    /// - Throws: возможная ошибка удаления файла из кэша
    func removeCache(for key: String) throws
    
    /// Очистить кэш
    ///
    /// - Throws: возможная ошибка удаления кэша
    func clearCache() throws
    
    /// Сжать кэш, если это необходимо (если его размер больше максимального размера)
    func compressCacheIfNeeded()
    
    /// Удалить устаревшие файлы, если такие имеются в кэше и текущий размер кэша превысил размер отведенного кэша
    func clearExpiredCacheIfNeeded()
}
