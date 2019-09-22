//
//  ShowPostInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import WebKit
import ZamzamUI

// Scene namespace
enum ShowPostAPI {}

protocol ShowPostModuleType {
    func resolve(with viewController: ShowPostDisplayable?) -> ShowPostActionable
    func resolve(with viewController: ShowPostDisplayable?) -> ShowPostPresentable
    func resolve(with inputs: ShowPostAPI.RoutableInputs) -> ShowPostRoutable
}

protocol ShowPostActionable: AppActionable {
    func fetchPost(with request: ShowPostAPI.Request)
    func fetchByURL(with request: ShowPostAPI.FetchWebRequest)
    func toggleFavorite(with request: ShowPostAPI.FavoriteRequest)
}

protocol ShowPostPresentable: AppPresentable {
    func presentPost(for response: ShowPostAPI.Response)
    func presentPost(error: DataError)
    
    func presentByURL(for response: ShowPostAPI.FetchWebResponse)
    
    func presentToggleFavorite(for response: ShowPostAPI.FavoriteResponse)
}

protocol ShowPostDisplayable: class, AppDisplayable {
    func displayPost(with viewModel: ShowPostAPI.ViewModel)
    func displayByURL(with viewModel: ShowPostAPI.WebViewModel)
    func display(isFavorite: Bool)
}

protocol ShowPostRoutable: AppRoutable {
    func listPosts(params: ListPostsAPI.Params)
}

protocol ShowPostLoadable {
    func loadData(for id: Int)
}

extension ShowPostAPI {
    
    struct RoutableInputs {
        weak var viewController: UIViewController?
        weak var listPostsDelegate: ListPostsDelegate?
    }
    
    struct Request {
        let postID: Int
    }
    
    struct FetchWebRequest {
        let url: String
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
    
    struct FavoriteRequest {
        let postID: Int
    }
    
    struct Response {
        let post: PostType
        let media: MediaType?
        let categories: [TermType]
        let tags: [TermType]
        let author: AuthorType?
        let favorite: Bool
    }
    
    struct FetchWebResponse {
        let post: PostType?
        let term: TermType?
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
    
    struct FavoriteResponse {
        let favorite: Bool
    }
    
    struct ViewModel {
        let title: String
        let link: String
        let content: String
        let commentCount: Int
        let favorite: Bool
    }
    
    struct PageViewModel {
        let title: String
        let content: String
        let date: String
        let categories: [String]
        let tags: [String]
    }
    
    struct AuthorViewModel {
        let name: String
        let content: String
        let avatar: String
    }
    
    struct WebViewModel {
        let postID: Int?
        let termID: Int?
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
}
