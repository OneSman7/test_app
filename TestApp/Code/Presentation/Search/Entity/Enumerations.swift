//
//  Enumerations.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Сервисы-источники музыкальных композиций
enum MusicTrackSearchServiceType: String {
    case itunes
    case lastfm
}

/// Результат поиска музыкальных композиций
///
/// - success: успех, связанное значение - набор композиций
/// - failure: провал, связанное значение - ошибка
enum MusicTrackSearchResult {
    case success(tracks: [MusicTrack])
    case failure(error: Error)
}
