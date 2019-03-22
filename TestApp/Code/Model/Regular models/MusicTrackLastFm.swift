//
//  MusicTrackLastFm.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

// Музыкальная композиция на сервисе Last.fm
struct MusicTrackLastFm: MusicTrack {
    
    /// Ссылка на обложку альбома
    var albumArtUrl: URL?
    
    /// Название
    var title: String = String()
    
    /// Исполнитель
    var artist: String?
    
    /// Название альбома
    var album: String?
    
    /// Ссылка на сервисе
    var url: URL?
    
    /// Кол-во слушателей
    var listenersCount: Int = 0
}
