//
//  SearchPresenter.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

class SearchPresenter: SearchViewOutput, SearchInteractorOutput, MusicTrackSeachResultCellEventHandler {
    
    weak var view: SearchViewInput!
    var router: SearchRouterInput!
    var interactor: SearchInteractorInput!
    
    var dataSourceFactory: MusicTrackSearchDataSourceFactory!
    var selectionItems: [String : MusicTrack]!
    
    var isLoadingSearchResults = false
    var currentService: MusicTrackSearchServiceType = .itunes
    var searchResultsByService: [MusicTrackSearchServiceType : MusicTrackSearchResult]!
    
    //MARK: - Helpers
    
    func redisplayResults() {
        
        guard let resultsForService = searchResultsByService?[currentService] else {
            view.displayEmptyContentView(for: nil)
            return
        }
        
        switch resultsForService {
            
        case .success(let tracks):
            
            guard !tracks.isEmpty else {
                view.displayEmptyContentView(for: nil)
                return
            }
            
            let configuration = dataSourceFactory.buildDataSourceConfiguration(from: tracks, eventHandler: self)
            
            selectionItems = configuration.selectionItems
            view.displaySearchResult(with: configuration.dataSource)
            
        case .failure(let error):
            view.displayEmptyContentView(for: error)
        }
    }
    
    //MARK: - SearchViewOutput
    
    func setupInitialState() {}
    
    func didSwitch(to service: MusicTrackSearchServiceType) {
        
        currentService = service
        
        guard !isLoadingSearchResults else { return }
        guard searchResultsByService != nil else { return }
        
        redisplayResults()
    }
    
    func didRequestSearch(with searchString: String, for service: MusicTrackSearchServiceType) {
        
        isLoadingSearchResults = true
        currentService = service
        
        view.showLoadingStatus()
        interactor.searchMusicTracks(with: searchString)
    }
    
    func didSelectResult(with itemId: String) {
        guard let trackUrl = selectionItems[itemId]?.url else { return }
        router.showSafariViewController(with: trackUrl)
    }
    
    //MARK: - SearchInteractorOutput
    
    func didFinishSearchingMusicTracks(for query: String, results: [MusicTrackSearchServiceType : MusicTrackSearchResult]) {
        
        isLoadingSearchResults = false
        view.hideLoadingStatus()
        
        if results.isEmpty {
            view.displayEmptyContentView(for: nil)
        }
        else {
            searchResultsByService = results
            redisplayResults()
        }
    }
    
    //MARK: - MusicTrackSeachResultCellEventHandler
    
    func didPressOnAlbumArtInItem(with itemId: String) {
        
        guard let iconUrl = selectionItems[itemId]?.albumArtUrl else { return }
        
        view.prepareExpandingForItem(with: itemId)
        router.showIconModule(with: iconUrl)
    }
}
