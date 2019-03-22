//
//  iTunesService.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Результат запроса на получение набора музыкальных композиций в iTunes
///
/// - success: успех, связанное значение - набор музыкальных композиций
/// - failure: провал, связанное значение - ошибка
enum iTunesMultipleMusicTrackResult {
    case success(tracks: [MusicTrackITunes])
    case failure(error: Error)
}

/// Обработчик результата получения набора музыкальных композиций в iTunes
typealias iTunesMultipleMusicTrackResultHandler = (iTunesMultipleMusicTrackResult) -> Void

/// Сервис для поиска музыки в iTunes
protocol iTunesService {
    
    /// Выполнить поиск музыкальных композиций в iTunes
    ///
    /// - Parameters:
    ///   - query: запрос
    ///   - completion: обработчик результата получения набора музыкальных композиций в iTunes
    /// - Returns: http запрос на поиск
    func searchMusicTracks(with query: String, completion: @escaping iTunesMultipleMusicTrackResultHandler) -> HTTPRequest
}
