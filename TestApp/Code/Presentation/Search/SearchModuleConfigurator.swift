//
//  SearchModuleConfigurator.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import UIKit

class SearchModuleConfigurator: BaseModuleConfigurator {
    
    override func configureModule(for view: UIViewController) {
        
        let itunesService = UIApplication.shared.serviceBuilder.getITunesService()
        let lastfmService = UIApplication.shared.serviceBuilder.getLastFmService()
        let notificationCenter = NotificationCenter.default
        
        let viewController = view as! SearchViewController
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        let router = SearchRouter()
        
        let stringFormatter = MusicTrackStringFormatterImplementation()
        let dataSourceFactory = MusicTrackSearchDataSourceFactoryImplementation()
        dataSourceFactory.stringFormatter = stringFormatter
        
        viewController.output = presenter
        viewController.notificationCenter = notificationCenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        presenter.dataSourceFactory = dataSourceFactory
        
        interactor.output = presenter
        interactor.itunesService = itunesService
        interactor.lastfmService = lastfmService
        
        router.transitionHandler = viewController
        router.toOtherModulesTransitionHandler = viewController
    }
}
