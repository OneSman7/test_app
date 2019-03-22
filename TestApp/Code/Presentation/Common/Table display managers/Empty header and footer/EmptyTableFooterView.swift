//
//  EmptyTableFooterView.swift
//  Portable
//
//  Created by Ivan Erasov on 14.02.2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

/// Cell object пустого футера
public struct EmptyTableFooterObject: FooterObject {
    
    public init() {}
    
    public init(footerHeight: CGFloat) {
        self.footerHeight = footerHeight
    }
    
    /// Высота футера
    public var footerHeight: CGFloat = CGFloat.leastNormalMagnitude
}

/// View пустого футера
open class EmptyTableFooterView: UITableViewHeaderFooterView, ConfigurableView {
    
    fileprivate var footerHeight: CGFloat = CGFloat.leastNormalMagnitude
    
    open func configure(with object: Any) {
        guard let cellObject = object as? EmptyTableFooterObject else { return }
        footerHeight = cellObject.footerHeight
    }
    
    override open func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return CGSize(width: targetSize.width, height: footerHeight)
    }
    
    override open func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return systemLayoutSizeFitting(targetSize)
    }
}
