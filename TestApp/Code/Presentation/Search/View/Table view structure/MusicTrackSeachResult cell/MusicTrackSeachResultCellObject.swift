//
//  MusicTrackSeachResultCellObject.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Cell object ячейки музыкальной композиции
struct MusicTrackSeachResultCellObject: CellObjectWithId {
    
    /// Идентификатор ячейки
    var itemId: String
    
    /// Ссылка на обложку альбома
    var albumArtUrl: URL?
    
    /// Название композиции
    var title: String
    
    /// Подзаголовок
    var subtitle: String
    
    /// Дополнительная ифнормация, отображаемая справа в ячейке
    var additionalInfo: String?
    
    /// Обработчик событий в ячейке
    weak var eventHandler: MusicTrackSeachResultCellEventHandler?
}
