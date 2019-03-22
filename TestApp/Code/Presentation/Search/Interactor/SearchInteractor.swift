//
//  SearchInteractor.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

class SearchInteractor: SearchInteractorInput {
    
    /// Состояние запроса на поиск музыкальных композиций
    struct MusicTrackSearchRequestState {
        
        /// HTTP запрос
        let request: HTTPRequest
        
        /// Найденные композиции
        var tracks: [MusicTrack]?
        
        /// Ошибка
        var error: Error?
        
        /// Завершился ли запрос на поиск
        var isRequestFinished: Bool {
            return tracks != nil || error != nil
        }
        
        init(request: HTTPRequest) {
            self.request = request
        }
    }
    
    weak var output: SearchInteractorOutput!
    
    var itunesService: iTunesService!
    var lastfmService: LastFmService!
    
    var currentSearches = [MusicTrackSearchServiceType : MusicTrackSearchRequestState]()
    
    //MARK: - Helpers
    
    func handleDidFinishSearchingMusicTracks(for query: String, in service: MusicTrackSearchServiceType, tracks: [MusicTrack]?, error: Error?) {
        
        currentSearches[service]?.tracks = tracks
        currentSearches[service]?.error = error
        
        for search in currentSearches {
            guard search.value.isRequestFinished else { return }
        }
        
        let results: [MusicTrackSearchServiceType : MusicTrackSearchResult] = currentSearches.mapValues({ state in
            
            if state.tracks != nil {
                return MusicTrackSearchResult.success(tracks: state.tracks!)
            }
            else {
                let searchError = state.error ?? NSError(domain: NSCocoaErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
                return MusicTrackSearchResult.failure(error: searchError)
            }
        })
        
        output.didFinishSearchingMusicTracks(for: query, results: results)
    }
    
    //MARK: - SearchInteractorInput
    
    func searchMusicTracks(with query: String) {
        
        currentSearches.forEach({ $0.value.request.cancel() })
        currentSearches.removeAll()
        
        let itunesRequest = itunesService.searchMusicTracks(with: query, completion: { [weak self] result in
            switch result {
            case .success(let tracks):
                self?.handleDidFinishSearchingMusicTracks(for: query, in: .itunes, tracks: tracks, error: nil)
            case .failure(let error):
                self?.handleDidFinishSearchingMusicTracks(for: query, in: .itunes, tracks: nil, error: error)
            }
        })
        
        currentSearches[.itunes] = MusicTrackSearchRequestState(request: itunesRequest)
        
        let lastfmRequest = lastfmService.searchMusicTracks(with: query, completion: { [weak self] result in
            switch result {
            case .success(let tracks):
                self?.handleDidFinishSearchingMusicTracks(for: query, in: .lastfm, tracks: tracks, error: nil)
            case .failure(let error):
                self?.handleDidFinishSearchingMusicTracks(for: query, in: .lastfm, tracks: nil, error: error)
            }
        })
        
        currentSearches[.lastfm] = MusicTrackSearchRequestState(request: lastfmRequest)
    }
}
