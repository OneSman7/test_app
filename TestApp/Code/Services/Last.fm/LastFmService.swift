//
//  LastFmService.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Результат запроса на получение набора музыкальных композиций в Last.fm
///
/// - success: успех, связанное значение - набор музыкальных композиций
/// - failure: провал, связанное значение - ошибка
enum LastFmMultipleMusicTrackResult {
    case success(tracks: [MusicTrackLastFm])
    case failure(error: Error)
}

/// Обработчик результата получения набора музыкальных композиций в Last.fm
typealias LastFmMultipleMusicTrackResultHandler = (LastFmMultipleMusicTrackResult) -> Void

/// Сервис для поиска музыки в Last.fm
protocol LastFmService {
    
    /// Выполнить поиск музыкальных композиций в Last.fm
    ///
    /// - Parameters:
    ///   - query: запрос
    ///   - completion: обработчик результата получения набора музыкальных композиций в Last.fm
    /// - Returns: http запрос на поиск
    func searchMusicTracks(with query: String, completion: @escaping LastFmMultipleMusicTrackResultHandler) -> HTTPRequest
}
