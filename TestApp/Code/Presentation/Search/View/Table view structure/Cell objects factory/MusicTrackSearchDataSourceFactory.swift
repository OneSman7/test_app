//
//  MusicTrackSearchDataSourceFactory.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Конфигурация источника данных для списка результатов поиска музыкальных композиций - источник данных и композиции по идентификатору ячейки
typealias MusicTrackSearchDataSourceConfiguration = (dataSource: TableViewDataSource, selectionItems: [String : MusicTrack])

/// Фабрика источника данных для списка результатов поиска музыкальных композиций
protocol MusicTrackSearchDataSourceFactory {
    
    /// Построить источник данных
    ///
    /// - Parameters:
    ///   - model: набор музыкальных композиций
    ///   - eventHandler: обработчик событий в ячейке музыкальной композиции
    /// - Returns: источник данных
    func buildDataSourceConfiguration(from model: [MusicTrack], eventHandler: MusicTrackSeachResultCellEventHandler?) -> MusicTrackSearchDataSourceConfiguration
}
