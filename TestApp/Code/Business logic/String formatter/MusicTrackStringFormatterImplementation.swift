//
//  MusicTrackStringFormatterImplementation.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

class MusicTrackStringFormatterImplementation: MusicTrackStringFormatter {
    
    func priceString(from price: Float, with currency: String) -> String {
        return String(format: "%.2f", price) + currency
    }
    
    func listenersString(for listenersCount: Int) -> String {
        
        let listenersMillions = listenersCount / 1000000
        let listenersThousands = listenersCount / 1000
        
        if listenersMillions >= 1 {
            return String(listenersMillions) + " млн."
        }
        else if listenersThousands >= 1 {
            return String(listenersThousands) + " тыс."
        }
        else {
            return String(listenersCount)
        }
    }
}
