//
//  ExpandControllerSegue.swift
//  TestApp
//
//  Created by Иван Ерасов on 22/03/2019.
//

import Foundation
import UIKit

/// UIViewController-источник перехода для ExpandControllerSegue
protocol ExpandTransitionSourceViewController {
    
    /// View, "из которой" начинается переход
    var originView: UIView? { get }
    
    /// Местоположение originView в координатах окна
    var originFrameInWindow: CGRect? { get }
}

/// Делегат перехода для ExpandControllerSegue
class ExpandControllerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    /// Ссылка на текущую view, "из которой" начинается переход
    weak var originView: UIView?
    
    /// Текущее местоположение originView в координатах окна
    var expandOriginFrame: CGRect?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let snapshot = originView?.snapshotView(afterScreenUpdates: true) else { return nil }
        guard expandOriginFrame != nil else { return nil }
        return ExpandControllerAnimator(originViewSnapshot: snapshot, originFrame: expandOriginFrame!)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard expandOriginFrame != nil else { return nil }
        return CollapseControllerAnimator(originFrame: expandOriginFrame!)
    }
}

/// Segue для показа UIViewController путем расширения из определенной части экрана/схлопывания в определенную часть экрана
class ExpandControllerSegue: UIStoryboardSegue {
    
    /// Делегат для перехода
    /// (var, чтобы создавался по требованию т.к. все static var по умолчанию lazy)
    fileprivate static var transitioningDelegate = ExpandControllerTransitioningDelegate()
    
    override func perform() {
        
        destination.modalPresentationCapturesStatusBarAppearance = true
        
        if let expandableController = source as? ExpandTransitionSourceViewController, let originView = expandableController.originView, let originFrame = expandableController.originFrameInWindow {
            
            ExpandControllerSegue.transitioningDelegate.originView = originView
            ExpandControllerSegue.transitioningDelegate.expandOriginFrame = originFrame
            
            destination.modalPresentationStyle = .custom
            destination.transitioningDelegate = ExpandControllerSegue.transitioningDelegate
        }
        else {
            ExpandControllerSegue.transitioningDelegate.originView = nil
            ExpandControllerSegue.transitioningDelegate.expandOriginFrame = nil
            destination.modalPresentationStyle = .fullScreen
        }
        
        source.present(destination, animated: true, completion: nil)
    }
}
