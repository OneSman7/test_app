//
//  MusicTrackStringFormatter.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

/// Форматтер строк для музыкальных композиций
protocol MusicTrackStringFormatter {
    
    /// Получить строку с ценой композиции
    ///
    /// - Parameters:
    ///   - price: цена
    ///   - currency: валюта
    /// - Returns: строка с ценой композиции
    func priceString(from price: Float, with currency: String) -> String
    
    /// Получить строку с кол-вом слушателей
    ///
    /// - Parameter listenersCount: кол-во слушателей
    /// - Returns: строка с кол-вом слушателей
    func listenersString(for listenersCount: Int) -> String
}
