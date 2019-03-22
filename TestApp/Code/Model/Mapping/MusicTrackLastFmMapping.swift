//
//  MusicTrackLastFmMapping.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

extension MusicTrackLastFm: MappableJsonResource {
    
    mutating func mapFromJson(_ json: NSDictionary) {
        
        title << json["name"]
        artist << json["artist"]
        url << (json["url"], MapToUrlFromStringTransform())
        listenersCount << json["listeners"]
        
        guard let urlsJson = json["image"] as? [NSDictionary] else { return }
        guard let largeImageUrlJson = urlsJson.first(where: { $0["size"] as? String == "large" }) else { return }
        
        albumArtUrl << (largeImageUrlJson["#text"], MapToUrlFromStringTransform())
    }
}
