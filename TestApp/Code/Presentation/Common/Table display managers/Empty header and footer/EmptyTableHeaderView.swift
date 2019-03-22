//
//  EmptyTableHeaderView.swift
//  Portable
//
//  Created by Ivan Erasov on 14.02.2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

/// Cell object пустого заголовка
public struct EmptyTableHeaderObject: HeaderObject {
    
    public init() {}
    
    public init(headerHeight: CGFloat) {
        self.headerHeight = headerHeight
    }
    
    /// Высота заголовка
    public var headerHeight: CGFloat = CGFloat.leastNormalMagnitude
}

/// View пустого заголовка
open class EmptyTableHeaderView: UITableViewHeaderFooterView, ConfigurableView {

    fileprivate var headerHeight: CGFloat = CGFloat.leastNormalMagnitude
    
    public func configure(with object: Any) {
        guard let cellObject = object as? EmptyTableHeaderObject else { return }
        headerHeight = cellObject.headerHeight
    }
    
    override open func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return CGSize(width: targetSize.width, height: headerHeight)
    }
    
    override open func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return systemLayoutSizeFitting(targetSize)
    }
}
