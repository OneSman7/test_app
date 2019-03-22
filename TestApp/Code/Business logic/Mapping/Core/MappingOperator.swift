//
//  MappingOperator.swift
//  Portable
//
//  Created by Ivan Erasov on 15.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

//MARK: - Хелперы

/// Попробовать смапить значение в переменную любого типа
///
/// - Parameters:
///   - value: значение
///   - variable: переменная
fileprivate func tryMappingAny<MappedType>(value: Any?, to variable: inout MappedType?) {
    
    if let castedValue = value as? MappedType {
        variable = castedValue
    }
    else if let number = value as? NSNumber {
        
        if variable is Bool?, let parsedValue = number.boolValue as? MappedType {
            variable = parsedValue
        }
        else if variable is String?, let parsedValue = number.stringValue as? MappedType {
            variable = parsedValue
        }
    }
}

/// Попробовать смапить значение в переменную конвертируемого из строки типа
///
/// - Parameters:
///   - value: значение
///   - variable: переменная
fileprivate func tryMappingString<MappedType: LosslessStringConvertible>(value: Any?, to variable: inout MappedType?) {
    
    if let string = value as? String, let parsedValue = MappedType(string) {
        variable = parsedValue
    }
    else {
        tryMappingAny(value: value, to: &variable)
    }
}

/// Попробовать смапить значение в переменную типа числа с плавающей точкой
///
/// - Parameters:
///   - value: значение
///   - variable: переменная
fileprivate func tryMappingFloat<MappedType: BinaryFloatingPoint & LosslessStringConvertible>(value: Any?, to variable: inout MappedType?) {
    
    if let number = value as? NSNumber {
        variable = MappedType(number.doubleValue)
    }
    else {
        tryMappingString(value: value, to: &variable)
    }
}

/// Попробовать смапить значение в переменную типа целого числа
///
/// - Parameters:
///   - value: значение
///   - variable: переменная
fileprivate func tryMappingInteger<MappedType: BinaryInteger & LosslessStringConvertible>(value: Any?, to variable: inout MappedType?) {
    
    if let number = value as? NSNumber {
        variable = MappedType(clamping: number.int64Value)
    }
    else {
        tryMappingString(value: value, to: &variable)
    }
}

//MARK: - Оператор маппинга

// Определение оператора
// infix operator <<

// Т.к. оператор совпадает по сигнатуре с побитовым сдвигом (тоже <<), то НЕ определяем его повторно,
// тем самым просто расширяя стандартный оператор

// Если определить его повторно в основном проекте ничего не произойдет, если сделать это в
// библиотеке (другом модуле), то Swift просто перестанет воспринимать наши переопределенные варианты
// (см. https://stackoverflow.com/questions/27049129/swift-how-to-create-custom-operators-to-use-in-other-modules)

public func << <MappedType>(left: inout MappedType?, right: MappedType) {
    left = right
}

public func << <MappedType>(left: inout MappedType, right: Any?) {
    var leftInQuestion: MappedType? = left
    tryMappingAny(value: right, to: &leftInQuestion)
    left = leftInQuestion ?? left
}

public func << <MappedType>(left: inout MappedType?, right: Any?) {
    tryMappingAny(value: right, to: &left)
}

public func << <MappedType: LosslessStringConvertible>(left: inout MappedType, right: Any?) {
    var leftInQuestion: MappedType? = left
    tryMappingString(value: right, to: &leftInQuestion)
    left = leftInQuestion ?? left
}

public func << <MappedType: LosslessStringConvertible>(left: inout MappedType?, right: Any?) {
    tryMappingString(value: right, to: &left)
}

public func << <MappedType: BinaryFloatingPoint & LosslessStringConvertible>(left: inout MappedType, right: Any?) {
    var leftInQuestion: MappedType? = left
    tryMappingFloat(value: right, to: &leftInQuestion)
    left = leftInQuestion ?? left
}

public func << <MappedType: BinaryFloatingPoint & LosslessStringConvertible>(left: inout MappedType?, right: Any?) {
    tryMappingFloat(value: right, to: &left)
}

public func << <MappedType: BinaryInteger & LosslessStringConvertible>(left: inout MappedType, right: Any?) {
    var leftInQuestion: MappedType? = left
    tryMappingInteger(value: right, to: &leftInQuestion)
    left = leftInQuestion ?? left
}

public func << <MappedType: BinaryInteger & LosslessStringConvertible>(left: inout MappedType?, right: Any?) {
    tryMappingInteger(value: right, to: &left)
}

//MARK: - Операторы с переданным преобразователем значений
//Тут все просто - преобразователь выполняет всю работу

public func << <MappedType, Transform: MappedValueTransform>(left: inout MappedType, right: (Any?, Transform)) where Transform.MappedValueType == MappedType {
    if let transformedRight = right.1.transformToMappedType(right.0) {
        left = transformedRight
    }
}

public func << <MappedType, Transform: MappedValueTransform>(left: inout MappedType?, right: (Any?, Transform)) where Transform.MappedValueType == MappedType {
    let transformedRight: MappedType? = right.1.transformToMappedType(right.0)
    left = transformedRight
}

public func << <MappedType, Transform: MappedValueTransform>(left: inout [MappedType], right: (Any?, Transform)) where Transform.MappedValueType == MappedType {
    
    //гарантируем вызов реализации оператора с left: MappedType?
    var leftInQuestion: [MappedType]? = left
    leftInQuestion << right
    
    //а почему? а потому, что в милом нашему сердцу Swift полно типов, передающихся не по ссылке :)
    if let leftValue = leftInQuestion {
        left = leftValue
    }
}

public func << <MappedType, Transform: MappedValueTransform>(left: inout [MappedType]?, right: (Any?, Transform)) where Transform.MappedValueType == MappedType {
    
    if let array = right.0 as? NSArray {

        left = [MappedType]()
        
        for object in array {
            let mappedObject = right.1.transformToMappedType(object)
            if mappedObject != nil {
                left?.append(mappedObject!)
            }
        }
    }
}
