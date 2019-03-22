//
//  TableViewDataSource.swift
//  Portable
//
//  Created by Ivan Erasov on 25.01.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

/// Обновление источника данных таблицы TableViewDataSource
/// Используется для передачи данных об обновлениях из фабрик во view слой
///
/// - insertRows: добавление рядов
/// - insertSections: добавление секций
/// - deleteRows: удаление рядов
/// - deleteSections: удаление секций
/// - reloadRows: обновление рядов
/// - reloadSections: обновление секций
/// - moveRow: перемещение ряда
/// - moveSection: перемещение секции
public enum TableViewDataSourceUpdate {
    case insertRows(indexPaths: [IndexPath], animation: UITableView.RowAnimation)
    case insertSections(sections: IndexSet, animation: UITableView.RowAnimation)
    case deleteRows(indexPaths: [IndexPath], animation: UITableView.RowAnimation)
    case deleteSections(sections: IndexSet, animation: UITableView.RowAnimation)
    case reloadRows(indexPaths: [IndexPath], animation: UITableView.RowAnimation)
    case reloadSections(sections: IndexSet, animation: UITableView.RowAnimation)
    case moveRow(indexPathFrom: IndexPath, indexPathTo: IndexPath)
    case moveSection(sectionFrom: Int, sectionTo: Int)
}

/// Расширенный протокол, реализуя который делегат TableViewDataSource получает возможность управление операциями с данными в таблице
@objc
public protocol TableViewDataSourceDelegate: UITableViewDelegate {
    
    @objc optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    
    @objc optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    
    @objc optional func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    
    @objc optional func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

/// Класс, реализующий все методы, необходимые для конфигурации и работы с таблицей
open class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    /// Минимальное значение estimatedSectionHeaderHeight/estimatedSectionFooterHeight, при котором на ВСЕХ версиях системы система НЕ подставляет свои отступы
    fileprivate let estimatedHeaderFooterHeightForAutomaticLayout: CGFloat = 2
    
    fileprivate(set) public var dataStructure: TableViewDataSourceStructure
    
    open weak var delegate: UITableViewDelegate!
    
    /// Массив заголовков для построения индекса таблицы
    fileprivate(set) public var indexTitles: [String]?
    
    /// Маппинг заголовков индексации в номера секций, которые нужно отобразить при выборе данного заголовка
    fileprivate(set) public var indexSectionsMap: [String : Int]?
    
    public init(with structure : TableViewDataSourceStructure) {
        dataStructure = structure
        super.init()
    }
    
    public init(with structure: TableViewDataSourceStructure, and localDelegate: UITableViewDelegate) {
        delegate = localDelegate
        dataStructure = structure
        super.init()
    }
    
    /// Настроить для работы с переданной таблицей
    open func assign(to tableView: UITableView) {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
    }


    /// Добавить индексатор для таблицы
    ///
    /// - Parameters:
    ///   - titles: заголовки индексации
    ///   - sectionsMap: маппинг заголовков индексации в номера секций
    open func setSectionsIndex(with titles: [String], and sectionsMap: [String : Int]) {
        indexTitles = titles
        indexSectionsMap = sectionsMap
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return dataStructure.numberOfSections()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStructure.numberOfObjects(at: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Здесь нет проверки на возврат nil потому как если внезапно для indexPath, который существует для таблицы, вернулся пустой cellObject, это наша явная проблема и надо упасть еще в моменте дебага
        
        let cellObject = dataStructure.cellObject(at: indexPath)!
        
        let reuseIdentifier = type(of: cellObject).cellReuseIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        if let configurableCell = cell as? ConfigurableView {
            configurableCell.configure(with: cellObject)
        }
        
        return cell!
    }
    
    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return indexSectionsMap?[title] ?? 0
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (delegate as? TableViewDataSourceDelegate)?.tableView?(tableView, canEditRowAt: indexPath) ?? true
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let dataSourceDelegate = delegate as? TableViewDataSourceDelegate else { return }
        dataSourceDelegate.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (delegate as? TableViewDataSourceDelegate)?.tableView?(tableView, canMoveRowAt: indexPath) ?? false
    }
    
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let dataSourceDelegate = delegate as? TableViewDataSourceDelegate else { return }
        dataSourceDelegate.tableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        guard let headerObject = dataStructure.headerObject(for: section) else { return 0 }
        
        if let emptyHeaderObject = headerObject as? EmptyTableHeaderObject {
            return max(emptyHeaderObject.headerHeight, estimatedHeaderFooterHeightForAutomaticLayout)
        }
        
        return tableView.estimatedSectionHeaderHeight
    }


    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        
        guard let footerObject = dataStructure.footerObject(for: section) else { return 0 }
        
        if let emptyFooterObject = footerObject as? EmptyTableFooterObject {
            return max(emptyFooterObject.footerHeight, estimatedHeaderFooterHeightForAutomaticLayout)
        }
        
        return tableView.estimatedSectionFooterHeight
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerObject = dataStructure.headerObject(for: section)
        
        if let unwrapperdHeaderObject = headerObject {
            
            let identifier = type(of: unwrapperdHeaderObject).headerReuseIdentifier()
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            
            if let configurableHeader = header as? ConfigurableView {
                configurableHeader.configure(with: unwrapperdHeaderObject)
            }
            
            return header
        }
        
        return nil
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerObject = dataStructure.footerObject(for: section)
        
        if let unwrapperdFooterObject = footerObject {
            
            let identifier = type(of: unwrapperdFooterObject).footerReuseIdentifier()
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            
            if let configurableFooter = footer as? ConfigurableView {
                configurableFooter.configure(with: unwrapperdFooterObject)
            }
            
            return footer
        }
        
        return nil
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        delegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        delegate.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        delegate.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        delegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard delegate != nil else {
            return indexPath
        }
        
        if delegate!.responds(to: #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))) {
            return delegate?.tableView?(tableView, willSelectRowAt: indexPath)
        }

        return indexPath
    }
    
    open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard delegate != nil else {
            return indexPath
        }
        
        if delegate!.responds(to: #selector(UITableViewDelegate.tableView(_:willDeselectRowAt:))) {
            return delegate?.tableView?(tableView, willDeselectRowAt: indexPath)
        }
        
        return indexPath
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let style = delegate?.tableView?(tableView, editingStyleForRowAt: indexPath)
        return style ?? .none
    }
    
    open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
    }

    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return delegate?.tableView?(tableView, editActionsForRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let val =  delegate?.tableView?(tableView, shouldShowMenuForRowAt: indexPath)
        return val ?? false
    }
    
    open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        let val = delegate?.tableView?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender)
        return val ?? false
    }
    
    open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        delegate?.tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }
    
    // MARK: - ScrollView
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
}
