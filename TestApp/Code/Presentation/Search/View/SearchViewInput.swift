//
//  SearchViewInput.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import CoreGraphics

protocol SearchViewInput: class {
    
    func showLoadingStatus()
    
    func hideLoadingStatus()
    
    func displaySearchResult(with dataSource: TableViewDataSource)
    
    func displayEmptyContentView(for error: Error?)
    
    func prepareExpandingForItem(with itemId: String)
}
