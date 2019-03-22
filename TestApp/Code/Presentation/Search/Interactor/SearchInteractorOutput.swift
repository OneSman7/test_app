//
//  SearchInteractorOutput.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

protocol SearchInteractorOutput: class {
    
    func didFinishSearchingMusicTracks(for query: String, results: [MusicTrackSearchServiceType : MusicTrackSearchResult])
}
