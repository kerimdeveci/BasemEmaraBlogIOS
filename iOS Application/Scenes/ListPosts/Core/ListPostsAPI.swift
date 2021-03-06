//
//  ListPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

// Scene namespace
enum ListPostsAPI {}

protocol ListPostsCoreType {
    func dependency(with viewController: ListPostsDisplayable?) -> ListPostsActionable
    func dependency(with viewController: ListPostsDisplayable?) -> ListPostsPresentable
    
    func dependency(
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?
    ) -> ListPostsRouterable
    
    func dependency() -> ConstantsType
    func dependency() -> Theme
}

protocol ListPostsActionable: AppActionable {
    func fetchLatestPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchPopularPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchTopPickPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchPostsByTerms(with request: ListPostsAPI.FetchPostsByTermsRequest)
    func toggleFavorite(with request: ListPostsAPI.FavoriteRequest)
    func isFavorite(postID: Int) -> Bool
}

protocol ListPostsPresentable: AppPresentable {
    func presentLatestPosts(for response: ListPostsAPI.PostsResponse)
    func presentLatestPosts(error: DataError)
    
    func presentPopularPosts(for response: ListPostsAPI.PostsResponse)
    func presentPopularPosts(error: DataError)
    
    func presentTopPickPosts(for response: ListPostsAPI.PostsResponse)
    func presentTopPickPosts(error: DataError)
    
    func presentPostsByTerms(for response: ListPostsAPI.PostsResponse)
    func presentPostsByTerms(error: DataError)
    
    func presentToggleFavorite(for response: ListPostsAPI.FavoriteResponse)
}

protocol ListPostsDisplayable: class, AppDisplayable {
    func displayPosts(with viewModels: [PostsDataViewModel])
    func displayToggleFavorite(with viewModel: ListPostsAPI.FavoriteViewModel)
}

protocol ListPostsRouterable {
    func showPost(for model: PostsDataViewModel)
}

protocol ListPostsDelegate: class {
    func listPosts(_ viewController: UIViewController, didSelect postID: Int)
}

// MARK: - Request/Response

extension ListPostsAPI {
    
    enum FetchType {
        case latest
        case popular
        case picks
        case terms(Set<Int>)
    }
    
    struct Params {
        let fetchType: FetchType
        let title: String?
        let sort: ((PostType, PostType) -> Bool)?
        
        init(fetchType: FetchType, title: String? = nil, sort: ((PostType, PostType) -> Bool)? = nil) {
            self.fetchType = fetchType
            self.title = title
            self.sort = sort
        }
    }
}

extension ListPostsAPI {
    
    struct FetchPostsRequest {
        let sort: ((PostType, PostType) -> Bool)?
    }
    
    struct FetchPostsByTermsRequest {
        let ids: Set<Int>
        let sort: ((PostType, PostType) -> Bool)?
    }
    
    struct PostsResponse {
        let posts: [PostType]
        let media: [MediaType]
    }
}

extension ListPostsAPI {
    
    struct FavoriteRequest {
        let postID: Int
    }
    
    struct FavoriteResponse {
        let postID: Int
        let favorite: Bool
    }
    
    struct FavoriteViewModel {
        let postID: Int
        let favorite: Bool
    }
}
