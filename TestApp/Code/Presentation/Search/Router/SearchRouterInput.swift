//
//  SearchRouterInput.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import UIKit

protocol SearchRouterInput: class {
    
    func showIconModule(with imageUrl: URL)

    func showSafariViewController(with websiteUrl: URL)
}
