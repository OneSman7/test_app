//
//  SearchRouter.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import UIKit
import SafariServices

class SearchRouter: SearchRouterInput {
    
    weak var transitionHandler: UIViewController!
    weak var toOtherModulesTransitionHandler: DataTransferModuleController!
    
    let showIconFullscreenSegueIdentifier = "showiconFullscreen"
    
    //MARK: - SearchRouterInput
    
    func showIconModule(with imageUrl: URL) {
        toOtherModulesTransitionHandler.performSegue(with: showIconFullscreenSegueIdentifier, sender: nil) { controller in
            controller.configureModule(with: imageUrl)
        }
    }
    
    func showSafariViewController(with websiteUrl: URL) {
        let safariController = SFSafariViewController(url: websiteUrl)
        transitionHandler.present(safariController, animated: true, completion: nil)
    }
}
