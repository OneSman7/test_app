//
//  ExpandControllerAnimator.swift
//  TestApp
//
//  Created by Иван Ерасов on 22/03/2019.
//

import Foundation
import UIKit

/// Аниматор перехода показа экрана для ExpandControllerSegue
class ExpandControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let originViewSnapshot: UIView
    let originFrame: CGRect
    
    init(originViewSnapshot: UIView, originFrame: CGRect) {
        self.originViewSnapshot = originViewSnapshot
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to),
              let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let toViewOriginFrame = containerView.convert(originFrame, from: nil)
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        
        originViewSnapshot.frame = toViewOriginFrame
        
        toView.frame = toViewFinalFrame
        toView.isHidden = true
        
        containerView.addSubview(originViewSnapshot)
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { [weak self] in
            self?.originViewSnapshot.frame = toViewFinalFrame
        }) { [weak self] _ in
            self?.originViewSnapshot.removeFromSuperview()
            toView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

/// Аниматор перехода скрытия экрана для ExpandControllerSegue
class CollapseControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from),
              let snapshot = fromView.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext.containerView
        let initialFrame = containerView.convert(originFrame, from: nil)
        
        snapshot.frame = fromView.frame
        containerView.addSubview(snapshot)
        fromView.removeFromSuperview()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot.frame = initialFrame
        }) { _ in
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

