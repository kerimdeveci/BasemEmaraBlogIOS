//
//  SearchPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

class SearchPostsViewController: UIViewController {
    
    // MARK: - Controls

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: SimplePostTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    private lazy var searchController = UISearchController(searchResultsController: nil).with {
        $0.searchResultsUpdater = self
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = .localized(.searchPlaceholder)
        $0.searchBar.scopeButtonTitles = [
            .localized(.searchAllScope),
            .localized(.searchTitleScope),
            .localized(.searchContentScope),
            .localized(.searchKeywordsScope)
        ]
    }
    
    @IBOutlet private var emptyPlaceholderView: UIView!
    
    // MARK: - Dependencies
    
    var core: SearchPostsCoreType?
    
    private lazy var action: SearchPostsActionable? = core?.dependency(with: self)
    private lazy var router: SearchPostsRouterable? = core?.dependency(with: self)
    
    private lazy var constants: ConstantsType? = core?.dependency()
    private lazy var theme: Theme? = core?.dependency()

    // MARK: - State
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    var searchText: String?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Setup

extension SearchPostsViewController {
    
    private func configure() {
        // Handles switching tabs while focused
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    public func loadData() {
        guard let searchText = searchText else {
            action?.fetchPopularPosts(
                with: SearchPostsAPI.PopularRequest()
            )
            
            return
        }
        
        self.searchText = nil
        searchController.isActive = true
        searchController.searchBar.text = searchText
        searchData(for: searchText, with: 0)
    }
    
    private func searchData(for text: String, with scope: Int) {
        action?.fetchSearchResults(
            with: PostAPI.SearchRequest(
                query: text,
                scope: {
                    switch scope {
                    case 1:
                        return .title
                    case 2:
                        return .content
                    case 3:
                        return .terms
                    default:
                        return .all
                    }
                }()
            )
        )
    }
}

// MARK: - Scene

extension SearchPostsViewController: SearchPostsDisplayable {

    func displayPosts(with viewModels: [PostsDataViewModel]) {
        tableViewAdapter.reloadData(with: viewModels)
    }
}

// MARK: - Delegates

extension SearchPostsViewController: UISearchResultsUpdating {
    private static var searchLimiter = Debouncer(limit: 0.5)
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return loadData()
        }
        
        // Skip irrelevant search until some characters
        guard text.count > 1 else { return }
        
        SearchPostsViewController.searchLimiter.execute { [weak self] in
            self?.searchData(
                for: text,
                with: searchController.searchBar.selectedScopeButtonIndex
            )
        }
    }
}

extension SearchPostsViewController: PostsDataViewDelegate {
    
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int {
        let isEmpty = tableViewAdapter.viewModels?.isEmpty == true
        tableView.backgroundView = isEmpty ? emptyPlaceholderView : nil
        tableView.separatorStyle = isEmpty ? .none : .singleLine
        return 1
    }
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router?.showPost(for: model)
    }
}

extension SearchPostsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let text = searchController.searchBar.text else { return }
        searchData(for: text, with: selectedScope)
    }
}

@available(iOS 13.0, *)
extension SearchPostsViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        guard let constants = constants, let theme = theme else { return nil }
        return UIContextMenuConfiguration(for: model, at: indexPath, from: dataView, delegate: self, constants: constants, theme: theme)
    }
    
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {
        router?.showPost(for: model)
    }
}
