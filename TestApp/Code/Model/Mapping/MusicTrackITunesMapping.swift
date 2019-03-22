//
//  MusicTrackITunesMapping.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

extension MusicTrackITunes: MappableJsonResource {
    
    mutating func mapFromJson(_ json: NSDictionary) {
        
        albumArtUrl << (json["artworkUrl100"], MapToUrlFromStringTransform())
        title << json["trackName"]
        artist << json["artistName"]
        album << json["collectionName"]
        url << (json["trackViewUrl"], MapToUrlFromStringTransform())
        price << json["trackPrice"]
        priceCurrency << json["currency"]
    }
}
