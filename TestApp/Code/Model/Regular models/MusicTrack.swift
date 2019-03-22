//
//  MusicTrack.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Музыкальная композиция
protocol MusicTrack {
    
    /// Ссылка на обложку альбома
    var albumArtUrl: URL? { get }
    
    /// Название
    var title: String { get }
    
    /// Исполнитель
    var artist: String? { get }
    
    /// Название альбома
    var album: String? { get }
    
    /// Ссылка на сервисе
    var url: URL? { get }
}
