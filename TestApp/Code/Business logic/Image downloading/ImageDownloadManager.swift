//
//  ImageDownloader.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import UIKit

/// Результат скачивания изображения
///
/// - success: успех, связанное значение - изображение
/// - failure: провал, связанное значение - ошибка
enum ImageDownloadResult {
    case success(image: UIImage)
    case failure(error: Error)
}

/// Обработчик результата скачивания изображения
typealias ImageDownloadResultHandler = (ImageDownloadResult) -> Void

/// Менеджер скачивания и кеширования изображений
protocol ImageDownloadManager {
    
    /// Загрузить и закешировать изображение
    ///
    /// - Parameters:
    ///   - url: ссылка на изображение
    ///   - completion: обработчик результата скачивания изображения
    func loadImage(at url: URL?, completion: @escaping ImageDownloadResultHandler)
    
    /// Отменить загрузку изображения
    ///
    /// - Parameter url: ссылка на изображение
    func cancelLoadImage(at url: URL?)
    
    /// Удалить устаревшие файлы, если такие имеются в кэше и текущий размер кэша превысил размер отведенного кэша
    func clearExpiredCacheIfNeeded()
}
