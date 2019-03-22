//
//  UIImageViewExtensions.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation
import UIKit

extension UIImageView {
    
    fileprivate static var sharedImageUrlsByViewsHash = [Int : URL]()
    fileprivate typealias Class = UIImageView
    
    /// Скачать и показать изображение
    ///
    /// - Parameters:
    ///   - url: ссылка на изображение
    ///   - placeholder: плейсхолдер на время загрузки
    ///   - completion: обработчик завершения загрузки изображения
    func loadAndDisplayImage(from url: URL?, placeholder: UIImage? = nil, completion: ImageDownloadResultHandler? = nil) {
        
        guard url != nil else { return }
        
        let viewHashValue = hashValue
        image = placeholder
        
        if let currentUrl = Class.sharedImageUrlsByViewsHash[viewHashValue] {
            ImageDownloadManagerBuilder.sharedManager.cancelLoadImage(at: currentUrl)
        }
        
        ImageDownloadManagerBuilder.sharedManager.loadImage(at: url) { [weak self] result in
            
            // выполняется до проверки guard let strongSelf = self
            // т.к. view могла умереть, а очистить url все равно нужно
            Class.sharedImageUrlsByViewsHash[viewHashValue] = nil
            
            guard let strongSelf = self else { return }
            
            defer {
                if let completion = completion {
                    completion(result)
                }
            }
            
            switch result {
            case .success(let image):
                strongSelf.image = image
            default:
                return
            }
        }
        
        Class.sharedImageUrlsByViewsHash[viewHashValue] = url!
    }
}
