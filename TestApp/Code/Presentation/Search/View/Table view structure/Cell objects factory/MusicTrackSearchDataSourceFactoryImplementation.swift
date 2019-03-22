//
//  MusicTrackSearchDataSourceFactoryImplementation.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

class MusicTrackSearchDataSourceFactoryImplementation: MusicTrackSearchDataSourceFactory {
    
    var stringFormatter: MusicTrackStringFormatter!
    
    func obtainAdditionalInfo(for track: MusicTrack) -> String? {
        
        if let itunesTrack = track as? MusicTrackITunes {
            
            guard let price = itunesTrack.price else { return nil }
            guard let currency = itunesTrack.priceCurrency else { return nil }
            
            return stringFormatter.priceString(from: price, with: currency)
        }
        else if let lastfmTrack = track as? MusicTrackLastFm {
            guard lastfmTrack.listenersCount > 0 else { return nil }
            return stringFormatter.listenersString(for: lastfmTrack.listenersCount)
        }
        
        return nil
    }
    
    //MARK: - MusicTrackSearchDataSourceFactory
    
    func buildDataSourceConfiguration(from model: [MusicTrack], eventHandler: MusicTrackSeachResultCellEventHandler?) -> MusicTrackSearchDataSourceConfiguration {
        
        let dataStructure = TableViewDataSourceStructure()
        var selectionItems = [String : MusicTrack]()
        
        dataStructure.appendSection()
        
        for element in model {
            
            let subtitle = element.album ?? element.artist ?? String()
            let additionalInfo = obtainAdditionalInfo(for: element)
            
            let cellObject = MusicTrackSeachResultCellObject(itemId: UUID().uuidString,
                                                             albumArtUrl: element.albumArtUrl,
                                                             title: element.title,
                                                             subtitle: subtitle,
                                                             additionalInfo: additionalInfo,
                                                             eventHandler: eventHandler)
            
            dataStructure.appendCellObject(cellObject)
            selectionItems[cellObject.itemId] = element
        }
        
        let dataSource = TableViewDataSource(with: dataStructure)
        
        return MusicTrackSearchDataSourceConfiguration(dataSource: dataSource, selectionItems: selectionItems)
    }
}
