//
//  TableViewDataSourceStructure.swift
//  Portable
//
//  Created by Ivan Erasov on 25.01.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// Структура данных, которая хранит информацию о секциях и ячейках таблицы
open class TableViewDataSourceStructure {
    
    fileprivate var sectionsArray: [[CellObject]]
    fileprivate var sectionsHeaders: [Int: HeaderObject]
    fileprivate var sectionsFooters: [Int: FooterObject]
    
    public init() {
        sectionsArray = []
        sectionsHeaders = [:]
        sectionsFooters = [:]
    }
    
    /// Возвращает количество секций
    open func numberOfSections() -> Int {
        return sectionsArray.count
    }
    
    /// Возвращает количество ячеек в секции
    ///
    /// - Parameter section: секция
    /// - Returns: количество ячеек или 0, если такой секции не существует
    open func numberOfObjects(at section: Int) -> Int {
        
        if section >= sectionsArray.count {
            return 0
        }
        
        return sectionsArray[section].count
    }
    
    /// Возвращает объект заголовка для секции
    ///
    /// - Parameter section: секция
    /// - Returns: объект заголовка или nil, если такого заголовка не существует
    open func headerObject(for section: Int) -> HeaderObject? {
        return sectionsHeaders[section]
    }
    
    /// Возвращает объект футера для секции
    ///
    /// - Parameter section: секция
    /// - Returns: объект футера или nil, если такого футера не существует
    open func footerObject(for section: Int) -> FooterObject? {
        return sectionsFooters[section]
    }
    
    /// Вернуть объект ячейки по IndexPath
    ///
    /// - Parameter indexPath: IndexPath объекта
    /// - Returns: объект или nil, если IndexPath вне границ
    open func cellObject(at indexPath: IndexPath) -> CellObject? {
        
        //Проверка на то, что один из индексов выходит за границы имеющихся массивов
        guard !isIndexPathOutOfBounds(indexPath) else {
            return nil
        }
        
        return sectionsArray[indexPath.section][indexPath.row]
    }
    
    /// Проверяет содержит ли структура информацию хотя бы об одной непустой секции
    open func isEmpty() -> Bool {
        return sectionsArray.reduce(0, {$0 + $1.count}) == 0
    }
    
    /// Вернуть IndexPath для первого объекта, который пройдет тест
    ///
    /// - Parameter test: функция проверки объекта
    /// - Returns: IndexPath объекта или nil, если ни один объект не прошел тест
    open func indexPathOfFirstObjectPassing(_ test: (CellObject) -> Bool) -> IndexPath? {
        
        for (section, objects) in sectionsArray.enumerated() {
            for (row, object) in objects.enumerated() {
                if test(object) {
                    return IndexPath(row: row, section: section)
                }
            }
        }
        
        return nil
    }
    
    /// Выполнить для всех объектов функцию
    ///
    /// - Parameter function: функция, которую надо выполнить
    open func enumerateCellObjectsUsing(_ function: (CellObject, IndexPath) -> Void) {
        for (section, objects) in sectionsArray.enumerated() {
            for (row, object) in objects.enumerated() {
                function(object, IndexPath(row: row, section: section))
            }
        }
    }
    
    // MARK: - Методы для изменения структуры таблицы
    
    /// Метод добавления в структуру таблицы новой пустой секции
    open func appendSection() {
        sectionsArray.append([])
    }
    
    /// Метод добавления в структуру таблицы новой секции с заданным заголовоком
    ///
    /// - Parameter headerObject: объект заголовка
    open func appendSection(with headerObject: HeaderObject) {
        appendSection()
        appendHeaderObject(headerObject)
    }
    
    /// Метод добавления в структуру таблицы новой секции с заданным массивом объектов для конфигурации ячеек
    ///
    /// - Parameter cellObjects: массив объектов ячеек
    open func appendSection(with cellObjects: [CellObject]) {
        sectionsArray.append(cellObjects)
    }
    
    /// Метод добавления в структуру таблицы новой секции с заданным заголовоком и массивом объектов для конфигурации ячеек
    ///
    /// - Parameters:
    ///   - sectionHeader: объект заголовка
    ///   - cellObjects: массив объектов ячеек
    open func appendSection(with sectionHeader: HeaderObject?, and cellObjects: [CellObject]) {
        appendSection(with: cellObjects)
        if sectionHeader != nil {
            appendHeaderObject(sectionHeader!)
        }
    }
    
    /// Удалить секции по индексу
    ///
    /// - Parameter indexPaths: индексы секций
    open func removeSections(at indexPaths: [IndexPath]) {
        indexPaths.forEach{ sectionsArray.remove(at: $0.section) }
    }
    
    /// Добавить ячейку в текущую секцию
    ///
    /// - Parameter cellObject: объект ячейки
    open func appendCellObject(_ cellObject: CellObject) {
        
        var sectionContent = sectionsArray.last

        if sectionContent == nil {
            sectionContent = [cellObject]
            sectionsArray.append(sectionContent!)
        }
        else {
            sectionContent!.append(cellObject)
        }
        
        sectionsArray[sectionsArray.count - 1] = sectionContent!
    }
    
    /// Добавить ячейку по заданному indexPath, если это возможно
    ///
    /// - Parameters:
    ///   - cellObject: объект ячейки
    ///   - indexPath: indexPath ячейки
    open func addCellObject(_ cellObject: CellObject, to indexPath: IndexPath) {
        
        if indexPath.section < sectionsArray.count {
            
            var sectionContent = sectionsArray[indexPath.section]
            
            if indexPath.row <= sectionContent.count {
                sectionContent.insert(cellObject, at: indexPath.row)
            }
            
            sectionsArray[indexPath.section] = sectionContent
        }
        else if indexPath.section == sectionsArray.count && indexPath.row == 0 {
            appendSection(with: [cellObject])
        }
    }
    
    /// Удалить ячейку по IndexPath
    ///
    /// - Parameter indexPath: IndexPath ячейки
    /// - Returns: удаленный объект или nil, если IndexPath вне границ структуры
    @discardableResult open func removeCellObject(at indexPath: IndexPath) -> CellObject? {
        
        guard !isIndexPathOutOfBounds(indexPath) else {
            return nil
        }
        
        return sectionsArray[indexPath.section].remove(at: indexPath.row)
    }
    
    /// Заменить ячейку по IndexPath на другую, если IndexPath не выходит за границы
    ///
    /// - Parameters:
    ///   - indexPath: IndexPath ячейки
    ///   - cellObject: новый объект ячейки
    open func replaceCellObject(at indexPath: IndexPath, with cellObject: CellObject) {
        if !isIndexPathOutOfBounds(indexPath) {
            sectionsArray[indexPath.section][indexPath.row] = cellObject
        }
    }
    
    /// Добавить заголовок к последней секции
    ///
    /// - Parameter headerObject: объект заголовка
    open func appendHeaderObject(_ headerObject: HeaderObject) {
        sectionsHeaders[sectionsArray.count - 1] = headerObject
    }
    
    /// Добавить футер к последней секции
    ///
    /// - Parameter footerObject: объект футера
    open func appendFooterObject(_ footerObject: FooterObject) {
        sectionsFooters[sectionsArray.count - 1] = footerObject
    }
    
    /// Добавить заголовок к секции с заданным номером. Если такой секции не существует, то этот заголовок никогда не будет использован, однако, ошибки не произойдет
    ///
    /// - Parameters:
    ///   - headerObject: объект заголовка
    ///   - section: секция
    open func addHeaderObject(_ headerObject: HeaderObject, to section: Int) {
        sectionsHeaders[section] = headerObject
    }
    
    /// Добавить футер к секции с заданным номером. Если такой секции не существует, то этот футер никогда не будет использован, однако, ошибки не произойдет
    ///
    /// - Parameters:
    ///   - footerObject: объект футера
    ///   - section: секция
    open func addFooterObject(_ footerObject: FooterObject, to section: Int) {
        sectionsFooters[section] = footerObject
    }
    
    // MARK: - Вспомогательные методы
    
    /// Вспомогательная функция для определения, выходит ли заданный indexPath за границы существующей структуры
    fileprivate func isIndexPathOutOfBounds(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= sectionsArray.count || indexPath.row >= sectionsArray[indexPath.section].count
    }
}
