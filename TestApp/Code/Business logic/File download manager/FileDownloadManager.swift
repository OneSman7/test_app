//
//  FileDownloadManager.swift
//  Portable
//
//  Created by Ivan Erasov on 09.11.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Ошибки загрузки файла
///
/// - couldNotCreateDownloadCache: не удалось создать временный кэш для хранения загружаемых файлов
/// - emptyFileContents: содержимое скачанного файла пустое
public enum FileDownloadError: Error {
    case couldNotCreateDownloadCache
    case emptyFileContents
}

/// Результат загрузки файла
///
/// - success: успех, связанное значение - данные из файла и временная ссылка на него (временный кэш для хранения загружаемых файлов может быть очищен в любое время)
/// - failure: провал, связанное значение - ошибка
public enum FileDownloadResult {
    case success(data: Data, temporaryFileUrl: URL)
    case failure(error: Error)
}

/// Обработчик окончания загрузки файла
public typealias FileDownloadResultHandler = (FileDownloadResult) -> ()

/// Загрузчик для файлов
public protocol FileDownloadManager {
    
    /// Получить обновляемый прогресс загрузки файла (если он загружается)
    ///
    /// - Parameter url: веб-ссылка на файл
    /// - Returns: прогресс загрузки файла
    func downloadProgressForFile(at url: URL) -> Progress?
    
    /// Загрузить файл
    ///
    /// - Parameters:
    ///   - url: веб-ссылка на файл
    ///   - completion: обработчик окончания загрузки файла
    func downloadFile(at url: URL, completion: @escaping FileDownloadResultHandler)
    
    /// Загрузить файл с вызовом обработчика результата НЕ на главном потоке
    ///
    /// - Parameters:
    ///   - url: веб-ссылка на файл
    ///   - completion: обработчик окончания загрузки файла
    func downloadFileReportingOnUtilityThread(fileUrl: URL, completion: @escaping FileDownloadResultHandler)
    
    /// Отменить загрузку файла
    ///
    /// - Parameter url: веб-ссылка на файл
    func cancelDownloadForFile(at url: URL)
    
    /// Очистить временный кэш для хранения загружаемых файлов
    func clearTemporaryFileCache()
}
