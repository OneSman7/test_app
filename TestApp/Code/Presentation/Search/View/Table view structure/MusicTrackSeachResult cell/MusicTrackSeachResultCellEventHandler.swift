//
//  MusicTrackSeachResultCellEventHandler.swift
//  TestApp
//
//  Created by Иван Ерасов on 22/03/2019.
//

import Foundation

/// Обработчик событий в ячейке музыкальной композиции
protocol MusicTrackSeachResultCellEventHandler: class {
    
    /// Пользователь нажал на обложку альбома в ячейке
    ///
    /// - Parameter itemId: идентификатор ячейки
    func didPressOnAlbumArtInItem(with itemId: String)
}
