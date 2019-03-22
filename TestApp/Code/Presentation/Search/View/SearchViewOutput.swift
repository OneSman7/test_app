//
//  SearchViewOutput.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

protocol SearchViewOutput: class {
    
    func setupInitialState()
    
    func didSwitch(to service: MusicTrackSearchServiceType)
    
    func didRequestSearch(with searchString: String, for service: MusicTrackSearchServiceType)
    
    func didSelectResult(with itemId: String)
}
