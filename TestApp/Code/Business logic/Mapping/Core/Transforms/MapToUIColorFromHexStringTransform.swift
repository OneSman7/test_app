//
//  MapToUIColorFromHexStringTransform.swift
//  Portable
//
//  Created by Ivan Erasov on 21.01.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

/// Преобразователь строк с hex цвета в цвет
open class MapToUIColorFromHexStringTransform: MappedValueTransform {
    
    public typealias MappedValueType = UIColor
    public typealias InputValueType = String
    
    /// хелпер, который помогает достать компоненты цвета
    fileprivate enum ColorMasks: CUnsignedInt {
        
        case redMask    = 0xff0000
        case greenMask  = 0x00ff00
        case blueMask   = 0x0000ff
        
        static func redValue(_ value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & redMask.rawValue) >> 16
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func greenValue(_ value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & greenMask.rawValue) >> 8
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func blueValue(_ value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & blueMask.rawValue) >> 0
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
    }
    
    /// Возвращает цвет, созданный из заданной hex-строки с заданной прозрачностью
    ///
    /// - parameter hex:   hex-строка
    /// - parameter alpha: прозрачность
    ///
    /// - returns: цвет
    fileprivate func colorWithHex(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        var c: CUnsignedInt = 0
        Scanner(string: hex).scanHexInt32(&c)
        return UIColor(red:ColorMasks.redValue(c), green:ColorMasks.greenValue(c), blue:ColorMasks.blueValue(c), alpha:alpha)
    }
    
    public init() {}
    
    open func transformToMappedType(_ value: Any?) -> UIColor? {
        if let colorString = value as? String {
            let strippedColorString = colorString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            return colorWithHex(strippedColorString)
        }
        return nil
    }
    
    // трансформация в input нам пока не нужна, поэтому трансформер будет писать всегда nil
    open func transformToInputType(_ value: Any?) -> String? {
        return nil
    }
}
