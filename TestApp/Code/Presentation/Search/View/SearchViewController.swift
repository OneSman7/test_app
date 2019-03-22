//
//  SearchViewController.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import UIKit

class SearchViewController: BaseViewController, SearchViewInput, UIBarPositioningDelegate, UISearchBarDelegate, UITableViewDelegate, ExpandTransitionSourceViewController {
    
    var output: SearchViewOutput!
    var notificationCenter: NotificationCenter!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var emptyContentView: UILabel!
    
    var tableViewDataDisplayManager: TableViewDataSource!
    
    let searchRequestTimeout: TimeInterval = 0.5
    lazy var searchRequestPerformer: DelayedSelectorPerformer = {
        return DelayedSelectorPerformer(target: self, selector: #selector(beginSearching(with:)))
    }()
    
    var initializedTableViewInsets = false
    var servicesBySegmentIndex: [MusicTrackSearchServiceType] = [.itunes, .lastfm]
    
    let noResultsText = "Не удалось найти подходящих результатов ☹️"
    let errorText = "Во время загрузки композиция произошла ошибка 😿"
    
    //MARK: - Методы
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.estimatedSectionHeaderHeight = 1
        tableView.estimatedSectionFooterHeight = 1
        
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(with:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(with:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        
        output.setupInitialState()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        guard !initializedTableViewInsets else { return }
        initializedTableViewInsets = true
        
        resetTableViewInsets()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        resetTableViewInsets()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    //MARK: - Actions
    
    @IBAction func unwindToSearch(_: UIStoryboardSegue) {}
    
    @objc func beginSearching(with text: String) {
        output.didRequestSearch(with: text, for: servicesBySegmentIndex[segmentControl.selectedSegmentIndex])
    }
    
    @IBAction func segmentControlValueChanged(control: UISegmentedControl) {
        
        let contentOffsetForTop = CGPoint(x: 0, y: -tableView.contentInset.top)
        tableView.setContentOffset(contentOffsetForTop, animated: false)
        
        // гарантируем мгновенное пролистывание наверх
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        
        output.didSwitch(to: servicesBySegmentIndex[segmentControl.selectedSegmentIndex])
    }
    
    //MARK: - SearchViewInput
    
    func showLoadingStatus() {
        
        tableView.isHidden = true
        emptyContentView.isHidden = true
        
        activityView.startAnimating()
    }
    
    func hideLoadingStatus() {
        activityView.stopAnimating()
        tableView.isHidden = false
    }
    
    func displaySearchResult(with dataSource: TableViewDataSource) {
        
        emptyContentView.isHidden = true
        
        tableViewDataDisplayManager = dataSource
        tableViewDataDisplayManager.delegate = self
        tableViewDataDisplayManager.assign(to: tableView)
        
        tableView.reloadData()
    }
    
    func displayEmptyContentView(for error: Error?) {
        
        tableView.isHidden = true
        activityView.isHidden = true
        
        emptyContentView.text = error != nil ? errorText : noResultsText
        emptyContentView.isHidden = false
    }
    
    func prepareExpandingForItem(with itemId: String) {
        
        let indexPath = tableViewDataDisplayManager.dataStructure.indexPathOfFirstObjectPassing { cellObject in
            guard let cellObjectWithId = cellObject as? CellObjectWithId else { return false }
            return cellObjectWithId.itemId == itemId
        }
        
        guard indexPath != nil else {
            originView = nil
            originFrameInWindow = nil
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath!) as? MusicTrackSeachResultCell else {
            originView = nil
            originFrameInWindow = nil
            return
        }
        
        originView = cell.albumArtView
        originFrameInWindow = cell.albumArtFrameInWindow
    }
    
    //MARK: - ExpandTransitionSourceViewController
    
    weak var originView: UIView?
    
    var originFrameInWindow: CGRect?
    
    //MARK: - UIBarPositioningDelegate
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        guard bar === navigationBar else { return .top }
        return .topAttached
    }
    
    //MARK: - Helpers
    
    func resetTableViewInsets() {
        
        var insets = UIEdgeInsets.zero
        
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        }
        else {
            insets.top = navigationController?.navigationBar.frame.height ?? 0
        }
        
        insets.top += navigationBar.frame.height
        insets.top += searchBar.frame.height
        
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    //MARK: - Нотификации
    
    @objc func keyboardWillShow(with notification: Notification) {
        
        guard let info = notification.userInfo,
            let keyboardEndSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            else { return }
        
        var insets = tableView.contentInset
        insets.bottom = keyboardEndSize.height

        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    @objc func keyboardWillHide(with notification: Notification) {
        resetTableViewInsets()
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchRequestPerformer.cancelDelayedPerform()
        
        let trimmedText = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let searchText = trimmedText, !searchText.isEmpty else { return }
        
        searchRequestPerformer.argument = searchText
        searchRequestPerformer.perform(afterDelay: searchRequestTimeout)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cellObject = tableViewDataDisplayManager.dataStructure.cellObject(at: indexPath) as? MusicTrackSeachResultCellObject else { return }
        output.didSelectResult(with: cellObject.itemId)
    }
}
